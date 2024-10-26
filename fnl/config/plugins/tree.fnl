(fn config []
  (fn prequire [what]
    (local (ok lib) (pcall #(require what)))
    (when ok lib))

  (local api (require :nvim-tree.api))
  (local lib (prequire :nvim-tree.lib))
  (local core (prequire :nvim-tree.core))
  (local tree (require :nvim-tree))
  (local view (require :nvim-tree.view))
  (local sidebar (require :config.sidebar))
  (local ev (require :nvim-tree.events))
  (var sb nil)
  (local expand-or-collapse
         (if (?. lib :expand_or_collapse) lib.expand_or_collapse
             (fn [node] (node:expand_or_collapse))))
  (local last-group-node
         (if (?. lib :get_last_group_node) lib.get_last_group_node
             (fn [node] (node:last_group_node))))
  (local get-node-at-cursor
         (if (?. lib :get_node_at_cursor) lib.get_node_at_cursor
             (fn [] (-?> (core.get_explorer) (: :get_node_at_cursor)))))

  (fn on_attach [bufnr]
    (fn km [mapping action ?desc]
      (local opts {:buffer bufnr
                   :noremap true
                   :silent true
                   :nowait true
                   :desc (-?>> ?desc (.. "nvim-tree: "))})
      (vim.keymap.set :n mapping action opts))

    (fn inject-node [f]
      (fn [?node ...]
        (f (or ?node (get-node-at-cursor)) ...)))

    (fn edit [mode node]
      ((. (require :nvim-tree.actions.node.open-file) :fn) mode
                                                           (if (and node.link_to
                                                                    (not node.nodes))
                                                               node.link_to
                                                               node.absolute_path)))

    (fn expand [node]
      (if (and node (not node.open)) (expand-or-collapse node)))

    (fn open-or-expand-or-dir-up [node]
      (if (= ".." node.name)
          ((. (require :nvim-tree.actions.root.change-dir) :fn) "..")
          (not (nil? node.nodes))
          (expand node)
          (edit :edit node)))

    (fn collapse [node]
      (if (and node (not (nil? node.nodes)) node.open)
          (expand-or-collapse node)))

    (fn enter [node]
      (if (= node.name "..")
          ((. (require :nvim-tree.actions.root.change-dir) :fn) "..")
          (not (nil? node.nodes))
          ((. (require :nvim-tree.actions.root.change-dir) :fn) (. (last-group-node node)
                                                                   :absolute_path))
          (edit :edit node)))

    (km :<2-LeftMouse> api.node.open.edit :Open)
    (km :<2-RightMouse> api.tree.change_root_to_node :CD)
    (km :<BS> api.node.navigate.parent_close "Close Directory")
    (km :<CR> (inject-node enter) :Open)
    (km :<Tab> api.node.open.preview "Open Preview")
    (km :l (inject-node open-or-expand-or-dir-up) :Open)
    (km :h (inject-node collapse) :Collapse)
    (km :s api.node.open.horizontal "Open: Horizontal Split")
    (km :v api.node.open.vertical "Open: Vertical Split")
    (km :r api.fs.rename :Rename)
    (km :<C-r> api.fs.rename_sub "Rename Full Path")
    (km :R api.tree.reload :Refresh)
    (km :I api.tree.toggle_gitignore_filter "Toggle Git Ignore")
    (km "." api.tree.toggle_hidden_filter "Toggle Dotfiles")
    (km "-" api.tree.change_root_to_parent :Up)
    (km :a api.fs.create :Create)
    (km :d api.fs.remove :Delete)
    (km :D api.fs.trash :Trash)
    (km "/" api.live_filter.start :Filter)
    (km :f api.live_filter.start :Filter)
    (km :F api.live_filter.clear "Filter Clear")
    (km :g? api.tree.toggle_help :Help)
    (km :q api.tree.close :Close)
    (km :x api.fs.cut :Cut)
    (km :c api.fs.copy.node :Copy)
    (km :p api.fs.paste :Paste)
    (km :y api.fs.copy.filename "Copy Name")
    (km :Y api.fs.copy.relative_path "Copy Relative Path")
    (km :gy api.fs.copy.absolute_path "Copy Absolute Path")
    (km :o api.node.run.system "System Open")
    (km "<" api.node.navigate.sibling.prev "Previous Sibling")
    (km ">" api.node.navigate.sibling.next "Next Sibling")
    (km :P api.node.navigate.parent "Parent Directory")
    (km :K api.node.navigate.sibling.first "First Sibling")
    (km :J api.node.navigate.sibling.last "Last Sibling")
    (km :t api.node.open.tab "Open: New Tab"))

  (tree.setup {:respect_buf_cwd true
               :update_cwd true
               :hijack_netrw true
               :hijack_cursor true
               :hijack_directories {:enable true :auto_open true}
               :diagnostics {:enable true}
               :actions {:change_dir {:enable true :global true}}
               :update_focused_file {:enable true :update_cwd true}
               :filters {:dotfiles true
                         :custom [:node_modules :dist :target :vendor]}
               :view {:signcolumn :yes}
               : on_attach
               :renderer {:indent_markers {:enable true}
                          :highlight_git true
                          :icons {:show {:git false
                                         :folder true
                                         :file true
                                         :folder_arrow false}}}})

  (fn is-open [] (view.is_visible))

  (fn find-file [?bufnr]
    (local bufnr (or ?bufnr (vim.api.nvim_get_current_buf)))
    (if (vim.api.nvim_buf_is_valid bufnr)
        (let [{:canonical canonical-path} (require :config.path)
              filepath (canonical-path (vim.api.nvim_buf_get_name bufnr))]
          (api.tree.find_file filepath))))

  (fn raw-open []
    (let [bufnr (vim.api.nvim_get_current_buf)]
      (if (not (is-open)) (api.tree.open))
      (find-file bufnr)))

  (fn close [] (view.close))

  (fn open []
    (sidebar.register :Explorer (fn [-close]
                                  (set sb {:close -close})
                                  (close))
                      (fn [ssb]
                        (set sb ssb)
                        (raw-open))))

  (fn toggle []
    ((if (is-open) close open)))

  (vim.keymap.set :n :<space>e toggle
                  {:silent true :noremap true :desc "Toggle nvim-tree"})
  (ev.subscribe ev.Event.TreeOpen
                (fn []
                  (vim.opt_local.fillchars:append "vert: ")
                  (set vim.wo.statusline "%#NvimTreeStatusLine#")
                  (let [winnr (view.get_winnr)
                        group (vim.api.nvim_create_augroup :NvimTreeResize
                                                           {:clear true})]
                    (vim.api.nvim_create_autocmd :WinScrolled
                                                 {:pattern (tostring winnr)
                                                  : group
                                                  :callback (fn []
                                                              (if (and sb
                                                                       sb.resize)
                                                                  (sb.resize (inc (vim.api.nvim_win_get_width winnr)))))})
                    (if (and sb sb.resize)
                        (sb.resize (inc (vim.api.nvim_win_get_width winnr)))))))
  (ev.subscribe ev.Event.Resize
                (fn []
                  (local winnr (view.get_winnr))
                  (if (and sb sb.resize)
                      (sb.resize (inc (vim.api.nvim_win_get_width winnr))))))
  (ev.subscribe ev.Event.TreeClose
                (fn []
                  (vim.api.nvim_create_augroup :NvimTreeResize {:clear true})
                  (when (and sb sb.close) (sb.close)))))

{:cmd [:NvimTreeToggle :NvimTreeFocus :NvimTreeFindFile :NvimTreeCollapse]
 :keys [{:mode :n :desc "Toggle nvim-tree" 1 :<space>e}]
 : config}


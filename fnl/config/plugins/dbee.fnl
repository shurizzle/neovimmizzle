(autoload [tools
           :dbee.layouts.tools
           common
           :dbee.ui.common
           dbee
           :dbee
           api_ui
           :dbee.api.ui
           sidebar
           :config.sidebar])

(var *sb* nil)

(fn config []
  (local augroup (vim.api.nvim_create_augroup :dbee-layout {:clear true}))
  (var open? false)

  (fn on-close []
    (set open? false)
    (when (and *sb* *sb*.close)
      (let [close *sb*.close]
        (set *sb* nil)
        (close))))

  (fn on-win-resize [winid]
    (when (and *sb* *sb*.resize)
      (*sb*.resize (inc (vim.api.nvim_win_get_width winid)))))

  (fn layout-open [self]
    (set self.egg (tools.save))
    (set self.windows [])
    (tools.make_only 0)
    (local editor-win (vim.api.nvim_get_current_win))
    (table.insert self.windows editor-win)
    (api_ui.editor_show editor-win)
    (vim.cmd (.. :bo self.result_height :split))
    (var result-win (vim.api.nvim_get_current_win))
    (table.insert self.windows result-win)
    (api_ui.result_show result-win)
    (common.configure_window_options result-win
                                     {:relativenumber false :spell false})
    (vim.cmd (.. :to self.drawer_width :vsplit))
    (var drawer-win (vim.api.nvim_get_current_win))
    (table.insert self.windows drawer-win)
    (api_ui.drawer_show drawer-win)
    (common.configure_window_options drawer-win
                                     {:relativenumber false :spell false})
    (vim.cmd (.. "belowright " self.call_log_height :split))
    (var log-win (vim.api.nvim_get_current_win))
    (table.insert self.windows log-win)
    (api_ui.call_log_show log-win)
    (common.configure_window_options log-win
                                     {:relativenumber false :spell false})
    (pcall vim.api.nvim_clear_autocmds {:group augroup})
    (vim.api.nvim_create_autocmd :WinResized
                                 {:pattern "*"
                                  :group augroup
                                  :callback (fn []
                                              (when (and vim.v.event
                                                         vim.v.event.windows)
                                                (each [_ win (ipairs vim.v.event.windows)]
                                                  (when (or (= win drawer-win)
                                                            (= win log-win))
                                                    (on-win-resize win))))
                                              false)})
    (vim.api.nvim_set_current_win editor-win)
    (set open? true))

  (fn layout-close [self]
    (pcall vim.api.nvim_clear_autocmds {:group augroup})
    (each [_ win (ipairs self.windows)]
      (pcall vim.api.nvim_win_close win false))
    (tools.restore self.egg)
    (set self.egg nil)
    (on-close))

  (fn layout-new [self ?opts]
    (local opts (or ?opts []))
    (each [_ k (ipairs [:drawer_width :result_height :call_log_height])]
      (when (and (. opts k) (< (. opts k) 0))
        (error (.. k "  must be a positive integer. Got: " (. opts k)))))
    {:windows []
     :drawer_width (or opts.drawer_width 40)
     :result_height (or opts.result_height 20)
     :call_log_height (or opts.call_log_height 20)
     :open layout-open
     :close layout-close
     :is_open #open?})

  (let [old-open dbee.open]
    (set dbee.open (fn []
                     (sidebar.register :Debug
                                       (fn [close]
                                         (dbee.close)
                                         (close))
                                       (fn [sb]
                                         (set *sb* sb)
                                         (old-open))))))
  (set dbee.toggle #(if (dbee.is_open) (dbee.close) (dbee.open)))
  (dbee.setup {:window_layout (layout-new)}))

{:lazy true
 :deps :nui
 :cmd :Dbee
 :build #(. (require :dbee) :install)
 : config}


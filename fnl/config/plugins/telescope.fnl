(local bindings
       {:ff  [:find_files "Telescope find files"]
        :fg  [:live_grep "Telescope live grep"]
        :fb  [:buffers "Telescope show buffers"]
        :fh  [:help_tags "Telescope help tags"]
        :fs  [:lsp_document_symbols "Telescope shopw workspace symbols"]
        :cwh ["diagnostics theme=get_dropdown" "Show workspace diagnostics"]
        :ch  ["diagnostics bufnr=0 theme=get_dropdown"
              "Show buffer diagnostics"]
        :cR  ["lsp_references theme=get_dropdown"
              "Show under-cursor references"]})

(fn config []
  (local ts (require :telescope))
  (ts.setup {:defaults   {:prompt_prefix "❯ "
                          :selection_caret "❯ "
                          :winblend 20}
             :extensions {:fzf       {:fuzzy true
                                      :override_generic_sorter true
                                      :override_file_sorter true
                                      :case_mode :smart_case}
                          :ui-select [((. (require :telescope.themes)
                                          :get_dropdown))]}})

  (each [_ ext (ipairs [:fzf :projects :ui-select :notify])]
    (ts.load_extension ext))
  (each [k [cmd desc] (pairs bindings)]
    (vim.keymap.set :n (.. :<leader> k) (.. "<cmd>Telescope " cmd "<CR>")
                    {:noremap true :silent true : desc})))

(fn init []
  (set vim.ui.select (fn [...]
                       (require :telescope)
                       (vim.ui.select ...))))

{:keys (icollect [k [_ desc] (pairs bindings)]
         {:mode :n : desc 1 (.. :<leader> k)})
 :cmd  [:Telescope]
 :dependencies [:rcarriga/nvim-notify
                :ahmedkhalf/project.nvim
                :nvim-telescope/telescope-fzf-native.nvim
                :nvim-telescope/telescope-ui-select.nvim]
 : init
 : config}

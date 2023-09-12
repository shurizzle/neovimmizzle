(fn config []
  ((. (require :toggleterm) :setup)
   {:open_mapping    :<leader>t
    :insert_mappings false
    :shade_terminals false
    :winbar          {:enabled true}})

  (vim.keymap.set :n :<leader>ft
                  "<cmd>TermSelect<cr>"
                  {:noremap true :silent true :desc "Search terminal"}))

{:lazy true
 :keys [{:mode :n :desc "Toggle Terminal" 1 :<leader>t}
        {:mode :n :desc "Search terminal" 1 :<leader>ft}]
 :cmd [:TermSelect :TermExec :ToggleTerm :ToggleTermToggleAll
       :ToggleTermSendVisualLines :ToggleTermSendCurrentLine :ToggleTermSetName]
 : config}

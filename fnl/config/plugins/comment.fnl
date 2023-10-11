(fn config []
  (local {: create_pre_hook}
         (require :ts_context_commentstring.integrations.comment_nvim))
  ((. (require :Comment) :setup) {:pre_hook (create_pre_hook)
                                  :mappings {:basic    false
                                             :extra    false
                                             :extended false}})
  (each [_ [mode f] (ipairs [[:n :comment_toggle_linewise_current]
                             [:x :comment_toggle_linewise_visual]])]
    (vim.keymap.set
      mode
      :<leader>c/
      (.. "<Plug>(" f ")")
      {:noremap true :silent true :expr false :desc "Toggle comments"})))

{:lazy true
 :dependencies :JoosepAlviste/nvim-ts-context-commentstring
 :keys [{:mode :n 1 :<leader>c/}
        {:mode :x 1 :<leader>c/}]
 : config}

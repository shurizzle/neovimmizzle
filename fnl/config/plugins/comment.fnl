(fn config []
  (local {: create_pre_hook}
         (require :ts_context_commentstring.integrations.comment_nvim))
  ((. (require :Comment) :setup) {:pre_hook (create_pre_hook)
                                  :mappings {:basic false
                                             :extra false
                                             :extended false}})
  (let [ft (require :Comment.ft)]
    (ft.set :wgsl ["// %s" "/*%s*/"]))
  (each [_ [mode f] (ipairs [[:n :comment_toggle_linewise_current]
                             [:x :comment_toggle_linewise_visual]])]
    (vim.keymap.set mode :<leader>c/ (.. "<Plug>(" f ")")
                    {:noremap true
                     :silent true
                     :expr false
                     :desc "Toggle comments"})))

{:enabled (not (has :nvim-0.10))
 :lazy true
 :deps :JoosepAlviste/nvim-ts-context-commentstring
 :keys [{:mode :n 1 :<leader>c/} {:mode :x 1 :<leader>c/}]
 : config}

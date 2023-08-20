(fn config []
  ((. (require :toggleterm) :setup)
   {:open_mapping :<leader>t
    :shade_terminals false
    :winbar {:enabled true}})
  (local {: Terminal : get_all} (require :toggleterm.terminal))

  (fn toggle [term ?size ?direction]
    (if (term:is_open)
        (term:shutdown)
        (term:open ?size ?direction)))

  (var current nil)

  (fn get-by-id [id]
    (some #(if (= $1.id id) $1) (get_all)))

  (fn set-current [id]
    (when (not= current id)
      (-?> current
           (get-by-id)
           (: :shutdown)))
    (set current id))

  (fn unset-current [id]
    (when (= current id)
      (set current nil)))

  (fn merge-fn [a b ...]
    (let [merged (if
                   (nil? a) b
                   (nil? b) b
                   (fn [...]
                     (a ...)
                     (b ...)))]
      (if (= 0 (select :# ...))
          merged
          (merge-fn merged ...))))

  (fn register-leave [term]
    (vim.api.nvim_create_autocmd
      :BufLeave
      {:buffer term.buffer
       :callback (fn [] (term:shutdown)) }))

  (fn float-term [?opts]
    (vim.validate {:?opts [?opts :t true]})
    (var opts (or ?opts {}))
    (set opts.on_open (merge-fn opts.on_open
                                (fn [term]
                                  (set-current term.id)
                                  (register-leave term))))
    (set opts.on_close (merge-fn opts.on_close
                                 (fn [{: id}] (unset-current id))))
    (set opts.direction :float)
    (set opts.float_opts {:border :double})

    (Terminal:new opts))

  (var lazygit nil)
  (set lazygit
       (float-term {:cmd :lazygit
                    :dir :git_dir
                    :display_name :lazygit
                    :on_open (fn [{:bufnr buffer}]
                               (vim.cmd :startinsert!)
                               (vim.keymap.set
                                 :n :q (fn [] (lazygit:shutdown))
                                 {:noremap true :silent true : buffer}))
                    :on_close (fn [_] (vim.cmd :startinsert!))}))
  (vim.keymap.set :n :<space>g
                  #(toggle lazygit)
                  {:noremap true :silent true :desc "Toggle floating lazygit"})
  (local temp (float-term {:display_name :temp}))
  (vim.keymap.set :n :<space>t
                  #(toggle temp)
                  {:noremap true :silent true :desc "Toggle floating term"})

  (vim.keymap.set :n :<leader>ft
                  "<cmd>TermSelect<cr>"
                  {:noremap true :silent true :desc "Search terminal"}))

{:lazy true
 :keys [{:mode :n :desc "Toggle floating lazygit" 1 :<space>g}
        {:mode :n :desc "Toggle floating term" 1 :<space>t}
        {:mode :n :desc "Toggle Terminal" 1 :<leader>t}
        {:mode :n :desc "Search terminal" 1 :<leader>ft}]
 :cmd [:TermSelect :TermExec :ToggleTerm :ToggleTermToggleAll
       :ToggleTermSendVisualLines :ToggleTermSendCurrentLine :ToggleTermSetName]
 : config}

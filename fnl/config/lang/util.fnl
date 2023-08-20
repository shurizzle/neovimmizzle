(fn default-timeout []
  (let [(ok res) (pcall (fn [] ((. ((. (require :notify) :_config)) :default_timeout))))]
    (or (and ok res) 5000)))

(fn notify-progress [init f-cb]
  (let [{: future : finally : and-then} (require :config.future)]
    (future
      (fn [resolve reject]
        (vim.schedule
          (fn []
            (var id nil)
            (local win (vim.api.nvim_get_current_win))

            (fn notify-new [msg ?log ?opts]
              (local log (or ?log vim.log.levels.INFO))
              (local opts (or ?opts []))
              (set opts.timeout false)
              (set id (vim.notify msg log opts))
              (copy id))

            (fn notify-edit [msg ?log ?opts]
              (local log (or ?log vim.log.levels.ERROR))
              (local opts (or ?opts []))
              (set opts.replace (copy id))
              (set opts.timeout (or opts.timeout (default-timeout)))
              (let [(ok res) (pcall
                               vim.api.nvim_win_call
                               win
                               (fn [] (vim.notify msg log opts)))]
                (if ok
                    res
                    (vim.notify msg log opts))))
            (doto (init notify-new)
              (finally (fn [...] (f-cb notify-edit ...)))
              (and-then resolve reject))))))))

{: notify-progress}

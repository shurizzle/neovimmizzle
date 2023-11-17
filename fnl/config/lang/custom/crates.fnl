(fn server [opts]
  (let [opts (or opts [])
        capabilities (or opts.capabilities [])
        on-request (or opts.on_request #nil)
        on-notify (or opts.on_notify #nil)
        handlers (or opts.handlers [])]
    (fn [dispatchers]
      (var closing? false)
      (var request-id 0)

      (fn code-actions [_ params]
        (fn format-title [name]
          (.. (: (name:sub 1 1) :upper)
              (: (name:gsub :_ " ") :sub 2)))

        (let [actions (require :crates.actions)
              bufnr (vim.api.nvim_get_current_buf)]
          (icollect [command action (pairs (actions.get_actions))]
            {:title (format-title command)
             : command
             :arguments #(vim.api.nvim_buf_call bufnr action)})))

      (fn request [method params callback]
        (pcall on-request method params)
        (let [handler (. handlers method)]
          (if
            handler (let [(response err) (handler method params)]
                      (values err response))
            (= :initialize method) (callback nil {: capabilities})
            (= :shutdown method) (callback)
            (= :textDocument/codeAction method) (callback nil (code-actions params))
            (and (= :workspace/executeCommand method))
              (if (= :function (type params.arguments))
                  (callback nil (params.arguments))
                  (callback (.. "Unknown command " params.command)))

            (callback (.. "Unknown method " method))))

        (set request-id (+ 1 request-id))
        (values true request-id))

      (fn notify [method params]
        (pcall on-notify method params)
        (when (= :exit method)
          (dispatchers.on_exit 0 15)))

      (fn is_closing [] closing?)

      (fn terminate [] (set closing? true))

      {: request
       : notify
       : is_closing
       : terminate})))

(fn enable []
  (vim.lsp.start
    {:name :crates-ls
     :cmd (server {:capabilities {:codeActionProvider true}})}))

(vim.api.nvim_create_autocmd :BufEnter
                             {:pattern  :Cargo.toml
                              :callback #(enable)})

nil

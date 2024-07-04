(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts
         {:on_attach (fn [client _]
                       (each [_ k (ipairs [:documentFormattingProvider
                                           :documentRangeFormattingProvider])]
                         (tset client.server_capabilities k false)))})
  (when bin (set opts.cmd [bin]))
  (lspconfig.kotlin_language_server.setup opts)
  lspconfig.kotlin_language_server)

(fn [cb]
  (bin-or-install :kotlin-language-server
                  (fn [bin]
                    (cb (config bin)))))

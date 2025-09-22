(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts
         {:on_attach (fn [client _]
                       (each [_ k (ipairs [:documentFormattingProvider
                                           :documentRangeFormattingProvider])]
                         (tset client.server_capabilities k false)))})
  (when bin (set opts.cmd [bin]))
  (lspconfig :kotlin_language_server opts)
  lspconfig.kotlin_language_server)

(fn [cb]
  (bin-or-install :kotlin-language-server
                  (fn [bin]
                    (cb (config bin)))))

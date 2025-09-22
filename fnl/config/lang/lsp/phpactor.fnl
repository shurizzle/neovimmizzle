(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts
         {:on_attach (fn [client _]
                       (each [_ k (ipairs [:documentFormattingProvider
                                           :documentRangeFormattingProvider])]
                         (tset client.server_capabilities k false)))})
  (when bin (set opts.cmd [bin :language-server]))
  (lspconfig :phpactor opts)
  lspconfig.phpactor)

(fn [cb]
  (bin-or-install :phpactor (fn [bin]
                              (cb (config bin)))))

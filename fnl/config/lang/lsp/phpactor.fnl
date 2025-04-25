(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts
         {:on_attach (fn [client _]
                       (each [_ k (ipairs [:documentFormattingProvider
                                           :documentRangeFormattingProvider])]
                         (tset client.server_capabilities k false)))})
  (when bin (set opts.cmd [bin :language-server]))
  (lspconfig.phpactor.setup opts)
  lspconfig.phpactor)

(fn [cb]
  (bin-or-install :phpactor (fn [bin]
                              (cb (config bin)))))

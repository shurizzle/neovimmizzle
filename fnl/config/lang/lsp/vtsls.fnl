(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts
         {:settings {:javascript {:format {:enable false}}
                     :typescript {:format {:enable false}}}
          :on_attach (fn [client _]
                       (each [_ k (ipairs [:documentFormattingProvider
                                           :documentRangeFormattingProvider])]
                         (tset client.server_capabilities k false)))})
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :vtsls opts)
  lspconfig.vtsls)

(fn [cb]
  (bin-or-install :vtsls (fn [bin]
                           (cb (config bin)))))

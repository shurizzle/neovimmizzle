(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :vtsls opts)
  lspconfig.vtsls)

(fn [cb]
  (bin-or-install :vtsls (fn [bin]
                           (cb (config bin)))))

(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.vtsls.setup opts)
  lspconfig.vtsls)

(fn [cb]
  (bin-or-install :vtsls (fn [bin]
                           (cb (config bin)))))


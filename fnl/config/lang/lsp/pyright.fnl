(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :pyright opts)
  lspconfig.pyright)

(fn [cb]
  (bin-or-install :pyright :pyright :pyright-langserver
                  (fn [bin]
                    (cb (config bin)))))

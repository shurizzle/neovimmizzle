(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.pyright.setup opts)
  lspconfig.pyright)

(fn [cb]
  (bin-or-install :pyright :pyright :pyright-langserver
                  (fn [bin]
                    (cb (config bin)))))


(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :server]))
  (lspconfig.ols.setup opts)
  lspconfig.ols)

(fn [cb]
  (bin-or-install :marksman (fn [bin]
                              (cb (config bin)))))

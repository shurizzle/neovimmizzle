(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.ols.setup opts)
  lspconfig.ols)

(fn [cb]
  (bin-or-install :ols (fn [bin]
                         (cb (config bin)))))

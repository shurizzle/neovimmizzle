(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :server]))
  (lspconfig :ols opts)
  lspconfig.ols)

(fn [cb]
  (bin-or-install :marksman (fn [bin]
                              (cb (config bin)))))

(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :ols opts)
  lspconfig.ols)

(fn [cb]
  (bin-or-install :ols (fn [bin]
                         (cb (config bin)))))

(autoload [{: bin-or-install} :config.lang.util
           lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.ols.setup opts)
  lspconfig.ols)

(fn [cb]
  (bin-or-install
    :ols
    (fn [bin]
      (cb (config bin)))))

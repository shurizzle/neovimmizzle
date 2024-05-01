(autoload [{: bin-or-install} :config.lang.util lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.gopls.setup opts)
  lspconfig.gopls)

(fn [cb]
  (bin-or-install :gopls (fn [bin]
                           (cb (config bin)))))

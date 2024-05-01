(autoload [{: bin-or-install} :config.lang.util lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.omnisharp.setup opts)
  lspconfig.omnisharp)

(fn [cb]
  (bin-or-install :omnisharp (fn [bin]
                               (cb (config bin)))))

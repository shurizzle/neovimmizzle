(autoload [{: bin-or-install} :config.lang.util lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.zls.setup opts)
  lspconfig.zls)

(fn [cb]
  (bin-or-install :zls (fn [bin]
                         (cb (config bin)))))

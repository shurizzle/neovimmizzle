(autoload [{: bin-or-install} :config.lang.util lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :lsp :stdio]))
  (lspconfig.taplo.setup opts)
  lspconfig.taplo)

(fn [cb]
  (bin-or-install :taplo (fn [bin]
                           (cb (config bin)))))

(autoload [{: bin-or-install} :config.lang.util lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.ruff_lsp.setup opts)
  lspconfig.ruff_lsp)

(fn [cb]
  (bin-or-install :ruff-lsp (fn [bin]
                              (cb (config bin)))))

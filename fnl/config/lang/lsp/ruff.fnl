(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :server]))
  (lspconfig :ruff opts)
  lspconfig.ruff)

(fn [cb]
  (bin-or-install :ruff (fn [bin]
                          (cb (config bin)))))

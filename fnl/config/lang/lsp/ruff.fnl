(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.ruff.setup opts)
  lspconfig.ruff)

(fn [cb]
  (bin-or-install :ruff-lsp (fn [bin]
                              (cb (config bin)))))

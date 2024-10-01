(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.jinja_lsp.setup opts)
  lspconfig.jinja_lsp)

(fn [cb]
  (bin-or-install :jinja-lsp (fn [bin]
                               (cb (config bin)))))


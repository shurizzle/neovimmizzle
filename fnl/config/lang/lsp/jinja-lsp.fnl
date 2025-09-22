(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :jinja_lsp opts)
  lspconfig.jinja_lsp)

(fn [cb]
  (bin-or-install :jinja-lsp (fn [bin]
                               (cb (config bin)))))

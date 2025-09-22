(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :omnisharp opts)
  lspconfig.omnisharp)

(fn [cb]
  (bin-or-install :omnisharp (fn [bin]
                               (cb (config bin)))))

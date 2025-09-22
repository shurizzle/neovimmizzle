(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :zls opts)
  lspconfig.zls)

(fn [cb]
  (bin-or-install :zls (fn [bin]
                         (cb (config bin)))))

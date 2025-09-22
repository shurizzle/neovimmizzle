(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :fennel_ls opts)
  lspconfig.fennel_ls)

(fn [cb]
  (bin-or-install :fennel-ls (fn [bin]
                               (cb (config bin)))))

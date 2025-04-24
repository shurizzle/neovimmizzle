(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.fennel_ls.setup opts)
  lspconfig.fennel_ls)

(fn [cb]
  (bin-or-install :fennel-ls (fn [bin]
                           (cb (config bin)))))


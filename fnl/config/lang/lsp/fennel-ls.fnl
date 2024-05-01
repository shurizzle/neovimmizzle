(autoload [lspconfig :lspconfig])

(fn [cb]
  (lspconfig.fennel_ls.setup [])
  (cb lspconfig.fennel_ls))


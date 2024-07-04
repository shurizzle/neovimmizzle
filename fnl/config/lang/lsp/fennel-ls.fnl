(local lspconfig (require :lspconfig))

(fn [cb]
  (lspconfig.fennel_ls.setup [])
  (cb lspconfig.fennel_ls))


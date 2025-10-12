(local {: lspconfig} (require :config.lang.util))

(fn [cb]
  (lspconfig :muon [])
  (cb lspconfig.muon))

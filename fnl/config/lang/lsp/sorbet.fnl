(local lspconfig (require :lspconfig))

(fn [cb]
  (lspconfig.sorbet.setup {:cmd [:bundle :exec :srb :tc :--lsp]})
  (cb lspconfig.sorbet))

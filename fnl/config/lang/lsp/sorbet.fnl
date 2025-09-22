(local {: lspconfig} (require :config.lang.util))

(fn [cb]
  (lspconfig :sorbet {:cmd [:bundle :exec :srb :tc :--lsp]})
  (cb lspconfig.sorbet))

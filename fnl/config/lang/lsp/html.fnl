(: (. (require :config.lang.installer) :html-lsp) :and-then
   (fn [] ((. (require :lspconfig) :html :setup) [])))

(: (. (require :config.lang.installer) :clangd) :and-then
   (fn [] ((. (require :lspconfig) :clangd :setup) [])))

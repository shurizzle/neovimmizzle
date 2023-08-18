(: (. (require :config.lang.installer) :pyright) :and-then
   (fn [] ((. (require :lspconfig) :pyright :setup) [])))

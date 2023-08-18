(: (. (require :config.lang.installer) :jdtls) :and-then
   (fn [] ((. (require :lspconfig) :jdtls :setup) [])))

(: (. (require :config.lang.installer) :zls) :and-then
   (fn [] ((. (require :lspconfig) :zls :setup) [])))

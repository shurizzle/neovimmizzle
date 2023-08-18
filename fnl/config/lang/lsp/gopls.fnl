(: (. (require :config.lang.installer) :gopls) :and-then
   (fn [] ((. (require :lspconfig) :gopls :setup) [])))

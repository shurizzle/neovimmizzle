(: (. (require :config.lang.installer) :elm-language-server) :and-then
   (fn [] ((. (require :lspconfig) :elmls :setup) [])))

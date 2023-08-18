(: (. (require :config.lang.installer) :yaml-language-server) :and-then
   (fn [] ((. (require :lspconfig) :yamlls :setup)
           {:settings {:yaml {:schemas ((. (require :schemastore)
                                           :json :schemas))}}})))

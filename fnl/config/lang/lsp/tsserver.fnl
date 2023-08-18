(: (. (require :config.lang.installer) :typescript-language-server) :and-then
   (fn [] ((. (require :lazy.core.loader) :load) :typescript.nvim [])))

(: (. (require :config.lang.installer) :ruff-lsp) :and-then
   (fn [] ((. (require :lspconfig) :ruff_lsp :setup) [])))

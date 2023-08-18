(let [{:pcall f-pcall : and-then} (require :future)]
  (and-then
    (f-pcall (. (require :lspconfig) :dartls :setup) [])
    (fn [] ((. (require :lazy.core.loader) :load) :flutter-tools.nvim []))))

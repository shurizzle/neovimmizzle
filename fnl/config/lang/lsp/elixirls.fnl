(: (. (require :config.lang.installer) :elixir-ls) :and-then
   (fn [] ((. (require :lspconfig) :elixirls :setup) {:cmd :elixir-ls})))

(fn [cb]
  ((. (require :lspconfig) :gleam :setup) [])
  (cb (. (require :lspconfig) :gleam)))

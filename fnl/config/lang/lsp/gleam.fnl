(local {: lspconfig} (require :config.lang.util))

(fn [cb]
  (lspconfig :gleam [])
  (cb lspconfig.gleam))

(local {: lspconfig} (require :config.lang.util))

(fn [cb] (lspconfig :oxfmt []) (cb lspconfig.oxfmt))

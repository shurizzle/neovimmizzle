(local {: lspconfig} (require :config.lang.util))

(fn [cb] (lspconfig :oxlint []) (cb lspconfig.oxlint))

(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :lsp :stdio]))
  (lspconfig.taplo.setup opts)
  lspconfig.taplo)

(fn [cb]
  (bin-or-install :taplo (fn [bin]
                           (cb (config bin)))))

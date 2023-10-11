(autoload [{: bin-or-install} :config.lang.util
           lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.pyright.setup opts)
  lspconfig.pyright)

(fn [cb]
  (bin-or-install
    :pyright-langserver
    :pyright
    :pyright-langserver
    (fn [bin]
      (cb (config bin)))))

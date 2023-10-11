(autoload [{: bin-or-install} :config.lang.util
           lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.eslint.setup opts)
  lspconfig.eslint)

(fn [cb]
  (bin-or-install
    [:eslint-language-server :vscode-eslint-language-server]
    :eslint-lsp
    :vscode-eslint-language-server
    (fn [bin]
      (cb (config bin)))))

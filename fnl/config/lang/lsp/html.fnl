(autoload [{: bin-or-install} :config.lang.util
           lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.html.setup opts)
  lspconfig.html)

(fn [cb]
  (bin-or-install
    [:vscode-html-language-server :vscode-html-languageserver]
    :html-lsp
    :vscode-html-language-server
    (fn [bin]
      (cb (config bin)))))

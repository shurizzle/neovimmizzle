(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :html opts)
  lspconfig.html)

(fn [cb]
  (bin-or-install [:vscode-html-language-server :vscode-html-languageserver]
                  :html-lsp :vscode-html-language-server
                  (fn [bin]
                    (cb (config bin)))))

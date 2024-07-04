(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.eslint.setup opts)
  lspconfig.eslint)

(fn [cb]
  (bin-or-install [:eslint-language-server :vscode-eslint-language-server]
                  :eslint-lsp :vscode-eslint-language-server
                  (fn [bin]
                    (cb (config bin)))))

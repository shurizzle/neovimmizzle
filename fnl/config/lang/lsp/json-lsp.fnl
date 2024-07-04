(local {: bin-or-install} (require :config.lang.util))
(local {:load lazy-load} (require :lazy.core.loader))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (lazy-load :neodev.nvim [])
  (local opts {:settings {:json {:schemas ((. (require :schemastore) :json
                                              :schemas))
                                 :validate {:enable true}}}})
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.jsonls.setup opts)
  lspconfig.jsonls)

(fn [cb]
  (bin-or-install [:vscode-json-language-server :vscode-json-languageserver]
                  :json-lsp :vscode-json-language-server
                  (fn [bin]
                    (cb (config bin)))))

(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts {:flags {:debounce_text_changes 1000
                       :allow_incremental_sync false}
               :settings {:eslint {:run :onSave
                                   :onReceiveConfigChange {:mode :debounce}}}
               :on_attach (fn [client]
                            (set client.server_capabilities.document_formatting
                                 false)
                            (set client.server_capabilities.document_range_formatting
                                 false)
                            (set client.server_capabilities.debounce_text_changes
                                 1000))})
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :eslint opts)
  lspconfig.eslint)

(fn [cb]
  (bin-or-install [:eslint-language-server :vscode-eslint-language-server]
                  :eslint-lsp :vscode-eslint-language-server
                  (fn [bin]
                    (cb (config bin)))))

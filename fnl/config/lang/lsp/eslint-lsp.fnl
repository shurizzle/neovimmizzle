(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts {:flags {:debounce_text_changes 1000}
               :capabilities (vim.tbl_deep_extend :force
                                                  (vim.lsp.protocol.make_client_capabilities)
                                                  {:textDocument {:completion {:completionItem {:snippetSupport false
                                                                                                :resolveSupport nil
                                                                                                :documentationFormat nil}}}})
               :on_attach (fn [client]
                            (set client.server_capabilities.document_formatting
                                 false)
                            (set client.server_capabilities.document_range_formatting
                                 false))})
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :eslint opts)
  lspconfig.eslint)

(fn [cb]
  (bin-or-install [:eslint-language-server :vscode-eslint-language-server]
                  :eslint-lsp :vscode-eslint-language-server
                  (fn [bin]
                    (cb (config bin)))))

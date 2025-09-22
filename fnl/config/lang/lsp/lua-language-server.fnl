(local {: bin-or-install : lspconfig} (require :config.lang.util))
(local {:load lazy-load} (require :lazy.core.loader))

(fn config [bin]
  (lazy-load :neodev.nvim [])
  (local opts {:on_attach (fn [client _]
                            (each [_ k (ipairs [:documentFormattingProvider
                                                :documentRangeFormattingProvider])]
                              (tset client.server_capabilities k false)))
               :settings {:Lua {:color {:mode :SemanticEnhanced}
                                :completion {:callSnippet :Both}
                                :telemetry {:enable false}}}})
  (when bin (set opts.cmd [bin]))
  (lspconfig :lua_ls opts)
  lspconfig.lua_ls)

(fn [cb]
  (bin-or-install :lua-language-server
                  (fn [bin]
                    (cb (config bin)))))

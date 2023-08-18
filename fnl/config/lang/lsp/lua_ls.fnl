(: (. (require :config.lang.installer) :lua-language-server) :and-then
   (fn []
    ((. (require :lazy.core.loader) :load) :neodev.nvim [])
    ((. (require :lspconfig) :lua_ls :setup)
     {:on_attach (fn [client _]
                   (each [_ k (ipairs [:documentFormattingProvider
                                       :documentRangeFormattingProvider])]
                     (tset client.server_capabilities k false)))
      :settings {:Lua {:color {:mode :SemanticEnhanced}
                       :completion {:callSnippet :Both}
                       :telemetry {:enable false}}}})))

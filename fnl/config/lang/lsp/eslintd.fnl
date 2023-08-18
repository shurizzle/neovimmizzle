(: (. (require :config.lang.installer) :eslint-lsp) :and-then
   (fn []
     ((. (require :lspconfig) :eslint :setup)
      {:on_attach (fn [client _]
                    (each [_ k (ipairs [:documentFormattingProvider
                                        :documentRangeFormattingProvider])]
                      (tset client.server_capabilities k false)))
       :settings {:format false}})))

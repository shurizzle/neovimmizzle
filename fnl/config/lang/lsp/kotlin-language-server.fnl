(: (. (require :config.lang.installer) :kotlin-language-server) :and-then
   (fn []
     ((. (require :lspconfig) :kotlin_language_server :setup)
      {:on_attach (fn [client _]
                    (each [_ k (ipairs [:documentFormattingProvider
                                        :documentRangeFormattingProvider])]
                      (tset client.server_capabilities k false)))})))

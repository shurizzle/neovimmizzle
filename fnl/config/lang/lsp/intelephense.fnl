(: (. (require :config.lang.installer) :intelephense) :and-then
   (fn []
     ((. (require :lspconfig) :intelephense :setup)
      {:on_attach (fn [client _]
                    (each [_ k (ipairs [:documentFormattingProvider
                                        :documentRangeFormattingProvider])]
                      (tset client.server_capabilities k false)))})))

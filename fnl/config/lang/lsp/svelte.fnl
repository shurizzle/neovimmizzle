(: (. (require :config.lang.installer) :svelte-language-server) :and-then
   (fn []
     ((. (require :lspconfig) :svelte :setup)
      {:on_attach (fn [client _]
                    (each [_ k (ipairs [:documentFormattingProvider
                                        :documentRangeFormattingProvider])]
                      (tset client.server_capabilities k false)))})))

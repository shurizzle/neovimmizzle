(fn on_attach [client _]
  (each [_ prop (ipairs [:documentFormattingProvider
                         :documentRangeFormattingProvider])]
    (tset client.server_capabilities prop false)))

{:lazy true
 :config (fn []
           ((. (require :typescript) :setup)
            {:server {: on_attach}}))}

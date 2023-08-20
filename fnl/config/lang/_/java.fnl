{:config (mkconfig :lsp :jdtls
           ((. (require :jdtls) :start_or_attach)
            {:cmd [:jdtls]}))}

(autoload [lspconfig :lspconfig])

(fn [cb]
  (lspconfig.ruby_ls.setup
    {:cmd [:bundle :exec :ruby-lsp]
     :init_options {:enabledFeatures [:documentHighlights
                                      :documentSymbols
                                      :foldingRanges
                                      :selectionRanges
                                      ; :semanticHighlighting
                                      :formatting
                                      :codeActions]}})
  (cb lspconfig.ruby_ls))

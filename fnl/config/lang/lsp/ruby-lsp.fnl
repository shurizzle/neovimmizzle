(local {: lspconfig} (require :config.lang.util))

(fn [cb]
  (lspconfig :ruby_ls
             {:cmd [:bundle :exec :ruby-lsp]
              :init_options {:enabledFeatures [:documentHighlights
                                               :documentSymbols
                                               :foldingRanges
                                               :selectionRanges
                                               ; :semanticHighlighting
                                               :formatting
                                               :codeActions]}})
  (cb lspconfig.ruby_ls))

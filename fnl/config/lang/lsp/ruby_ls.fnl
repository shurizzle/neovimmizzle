((. (require :config.future) :pcall)
 (fn []
   ((. (require :lspconfig) :ruby_ls :setup)
    {:cmd [:bundle :exec :ruby-lsp]
     :init_options {:enabledFeatures [:documentHighlights
                                      :documentSymbols
                                      :foldingRanges
                                      :selectionRanges
                                      ; :semanticHighlighting
                                      :formatting
                                      :codeActions]}})))
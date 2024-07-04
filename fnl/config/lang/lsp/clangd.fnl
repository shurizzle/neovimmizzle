(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts {:cmd [(or bin :clangd)
                     :--clang-tidy
                     :--completion-style=bundled
                     :--header-insertion=iwyu]
               :init_options {:clangdFileStatus true
                              :usePlaceholders true
                              :completeUnimported true
                              :semanticHighlighting true}})
  (lspconfig.clangd.setup opts)
  lspconfig.clangd)

(fn [cb]
  (bin-or-install :clangd (fn [bin]
                            (cb (config bin)))))

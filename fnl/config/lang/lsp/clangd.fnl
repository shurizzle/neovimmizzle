(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts {:cmd [(or bin :clangd)
                     :--clang-tidy
                     :--completion-style=bundled
                     :--header-insertion=iwyu]
               :init_options {:clangdFileStatus true
                              :usePlaceholders true
                              :completeUnimported true
                              :semanticHighlighting true}})
  (lspconfig :clangd opts)
  lspconfig.clangd)

(fn [cb]
  (bin-or-install :clangd #(cb (config $1))))

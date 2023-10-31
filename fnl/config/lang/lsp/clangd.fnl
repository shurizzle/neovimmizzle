(autoload [{: bin-or-install} :config.lang.util
           lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--clang-tidy :--clang-tidy-checks=*]))
  (lspconfig.clangd.setup opts)
  lspconfig.clangd)

(fn [cb]
  (bin-or-install
    :clangd
    (fn [bin]
      (cb (config bin)))))

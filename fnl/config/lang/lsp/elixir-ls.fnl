(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :elixirls opts)
  lspconfig.elixirls)

(fn [cb]
  (bin-or-install :elixir-ls (fn [bin]
                               (cb (config bin)))))

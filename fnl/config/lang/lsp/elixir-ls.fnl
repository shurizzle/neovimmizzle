(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.elixirls.setup opts)
  lspconfig.elixirls)

(fn [cb]
  (bin-or-install :elixir-ls (fn [bin]
                               (cb (config bin)))))

(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts {:cmd_env {:RUST_LOG :error}})
  (when bin (set opts.cmd [bin :lsp :stdio]))
  (lspconfig :taplo opts)
  lspconfig.taplo)

(fn [cb]
  (bin-or-install :taplo (fn [bin]
                           (cb (config bin)))))

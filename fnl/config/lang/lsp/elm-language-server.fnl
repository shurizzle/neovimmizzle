(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :elmls opts)
  lspconfig.elmls)

(fn [cb]
  (bin-or-install :elm-language-server
                  (fn [bin]
                    (cb (config bin)))))

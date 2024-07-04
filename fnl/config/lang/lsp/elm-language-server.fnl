(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.elmls.setup opts)
  lspconfig.elmls)

(fn [cb]
  (bin-or-install :elm-language-server
                  (fn [bin]
                    (cb (config bin)))))

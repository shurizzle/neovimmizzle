(autoload [{: bin-or-install} :config.lang.util
           lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.elmls.setup opts)
  lspconfig.elmls)

(fn [cb]
  (bin-or-install
    :elm-language-server
    (fn [bin]
      (cb (config bin)))))

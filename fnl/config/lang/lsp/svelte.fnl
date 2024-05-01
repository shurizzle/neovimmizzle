(autoload [{: bin-or-install} :config.lang.util lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.svelte.setup opts)
  lspconfig.svelte)

(fn [cb]
  (bin-or-install :svelteserver :svelte-language-server :svelteserver
                  (fn [bin]
                    (cb (config bin)))))

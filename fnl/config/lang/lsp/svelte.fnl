(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :svelte opts)
  lspconfig.svelte)

(fn [cb]
  (bin-or-install :svelteserver :svelte-language-server :svelteserver
                  (fn [bin]
                    (cb (config bin)))))

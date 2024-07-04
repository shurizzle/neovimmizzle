(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.svelte.setup opts)
  lspconfig.svelte)

(fn [cb]
  (bin-or-install :svelteserver :svelte-language-server :svelteserver
                  (fn [bin]
                    (cb (config bin)))))

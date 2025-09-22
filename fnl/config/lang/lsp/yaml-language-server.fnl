(local {: bin-or-install : lspconfig} (require :config.lang.util))
(local {:load lazy-load} (require :lazy.core.loader))

(fn config [bin]
  (lazy-load :neodev.nvim [])
  (local opts
         {:settings {:yaml {:schemas ((. (require :schemastore) :yaml :schemas))
                            :schemaStore {:enable false :url ""}}}})
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig :yamlls opts)
  lspconfig.yamlls)

(fn [cb]
  (bin-or-install :yaml-language-server
                  (fn [bin]
                    (cb (config bin)))))

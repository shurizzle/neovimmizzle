(autoload [{: bin-or-install}
           :config.lang.util
           {:load lazy-load}
           :lazy.core.loader
           lspconfig
           :lspconfig])

(fn config [bin]
  (lazy-load :neodev.nvim [])
  (local opts
         {:settings {:yaml {:schemas ((. (require :schemastore) :yaml :schemas))
                            :schemaStore {:enable false :url ""}}}})
  (when bin (set opts.cmd [bin :--stdio]))
  (lspconfig.yamlls.setup opts)
  lspconfig.yamlls)

(fn [cb]
  (bin-or-install :yaml-language-server
                  (fn [bin]
                    (cb (config bin)))))

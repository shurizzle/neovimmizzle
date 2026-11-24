(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (lspconfig :html-languageserver
             {:cmd [(or bin :html-languageserver) :--stdio]
              :filetypes [:html]
              :root_markers [:package.json :.git]
              :settings []
              :init_options {:provideFormatter true
                             :embeddedLanguages {:css true :javascript true}
                             :configurationSection [:html :css :javascript]}})
  lspconfig.html-languageserver)

(fn [cb]
  (bin-or-install :html-languageserver #(cb (config $1))))

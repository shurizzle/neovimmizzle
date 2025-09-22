(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts
         {:settings {:gopls {:hints {:assignVariableTypes true
                                     :compositeLiteralFields false
                                     :compositeLiteralTypes false
                                     :constantValues true
                                     :functionTypeParameters true
                                     :parameterNames false
                                     :rangeVariableTypes true}}}})
  (when bin (set opts.cmd [bin]))
  (lspconfig :gopls opts)
  lspconfig.gopls)

(fn [cb]
  (bin-or-install :gopls (fn [bin]
                           (cb (config bin)))))

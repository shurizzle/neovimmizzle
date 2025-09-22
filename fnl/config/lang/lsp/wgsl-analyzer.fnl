(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig :wgsl_analyzer opts)
  lspconfig.wgsl_analyzer)

(fn [cb]
  (bin-or-install [:wgsl-analyzer :wgsl_analyzer] :wgsl-analyzer :wgsl_analyzer
                  (fn [bin]
                    (cb (config bin)))))

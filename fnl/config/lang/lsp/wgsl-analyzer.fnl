(autoload [{: bin-or-install} :config.lang.util lspconfig :lspconfig])

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.wgsl_analyzer.setup opts)
  lspconfig.wgsl_analyzer)

(fn [cb]
  (bin-or-install [:wgsl-analyzer :wgsl_analyzer] :wgsl-analyzer :wgsl_analyzer
                  (fn [bin]
                    (cb (config bin)))))

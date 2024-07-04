(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin]
  (local opts [])
  (when bin (set opts.cmd [bin]))
  (lspconfig.wgsl_analyzer.setup opts)
  lspconfig.wgsl_analyzer)

(fn [cb]
  (bin-or-install [:wgsl-analyzer :wgsl_analyzer] :wgsl-analyzer :wgsl_analyzer
                  (fn [bin]
                    (cb (config bin)))))

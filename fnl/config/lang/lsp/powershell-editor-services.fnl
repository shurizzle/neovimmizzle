(local lspconfig (require :lspconfig))
(local installer (require :config.lang.installer))
(local {: mason-get-install-path} (require :config.lang.util))

(fn config [path]
  (local opts [])
  (when path (set opts.bundle_path path))
  (lspconfig.powershell_es.setup opts)
  lspconfig.powershell_es)

(fn [cb]
  (installer.get :powershell-editor-services
                 (fn [_ p]
                   (cb (config (-?> p (mason-get-install-path)))))))


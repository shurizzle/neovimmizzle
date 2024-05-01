(autoload [lspconfig :lspconfig installer :config.lang.installer])

(fn config [path]
  (local opts [])
  (when path (set opts.bundle_path path))
  (lspconfig.powershell_es.setup opts)
  lspconfig.powershell_es)

(fn [cb]
  (installer.get :powershell-editor-services
                 (fn [_ p]
                   (cb (config (-?> p (: :get_install_path)))))))

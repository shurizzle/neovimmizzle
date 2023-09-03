(: (. (require :config.lang.installer) :powershell-editor-services) :and-then
   (fn [p]
     ((. (require :lspconfig) :powershell_es :setup)
      {:bundle_path (p:get_install_path)})))

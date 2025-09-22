(local installer (require :config.lang.installer))

(fn config []
  (let [{: lspconfig} (require :config.lang.util)]
    (. lspconfig (. (require :typescript-tools.config) :plugin_name))))

(fn [cb]
  (let [tsserver (exepath :tsserver)]
    (if tsserver
        (cb (config))
        (installer.get :typescript-language-server
                       (fn [err p]
                         (if (and (not err) p)
                             (cb (config))
                             (cb (config))))))))

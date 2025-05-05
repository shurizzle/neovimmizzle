(local installer (require :config.lang.installer))

(fn config []
  (. (require :lspconfig) (. (require :typescript-tools.config) :plugin_name)))

(fn [cb]
  (let [tsserver (exepath :tsserver)]
    (if tsserver
        (cb (config))
        (installer.get :typescript-language-server
                       (fn [err p]
                         (if (and (not err) p)
                             (cb (config))
                             (cb (config))))))))


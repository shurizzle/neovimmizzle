(local {:join path-join} (require :config.path))
(local installer (require :config.lang.installer))

(fn config []
  ((. (require :typescript-tools) :setup) [])
  (. (require :lspconfig) :tsserver))

(fn [cb]
  (let [tsserver (exepath :tsserver)]
    (if tsserver
        (cb (config))
        (installer.get :typescript-language-server
                       (fn [err p]
                         (if (and (not err) p)
                             (cb (config))
                             (cb (config))))))))

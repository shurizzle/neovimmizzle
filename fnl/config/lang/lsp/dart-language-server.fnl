(fn [cb]
  ;; NOTE: flutter-tools doesn't work without flutter
  ;; ((. (require :flutter-tools) :setup) [])
  (local opts [])
  (let [bin (exepath :dart)]
    (when bin
      (set opts.cmd [bin :language-server :--protocol=lsp])))
  ((. (require :lspconfig) :dartls :setup) opts)
  (cb (. (require :lspconfig) :dartls)))

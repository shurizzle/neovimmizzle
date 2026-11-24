(local {: bin-or-install : lspconfig} (require :config.lang.util))

(fn config [bin apiKey]
  (lspconfig :fim-lsp
             {:cmd [(or bin :fim-lsp)]
              :init_options {:type :deepseek : apiKey}})
  lspconfig.fim-lsp)

(fn [cb]
  (let [[ok apiKey] [(pcall #(. (require :config.secrets) :deepseek))]]
    (if ok
        (bin-or-install :fim-lsp #(cb (config $1 apiKey)))
        (vim.notify (.. "No secrets module found: " apiKey) vim.log.levels.WARN
                    {:title :fim-lsp}))))

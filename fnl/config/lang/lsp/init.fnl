(let [{: generating-map} (require :config.generating_map)
      {:pcall f-pcall} (require :config.future)]
  (generating-map (fn [name]
                    (vim.validate {:name [name :s]})
                    (f-pcall require (.. :config.lang.lsp. name)))))

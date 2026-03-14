(local ft [:javascript
           :javascriptreact
           :javascript.jsx
           :typescript
           :typescriptreact
           :typescript.tsx])

(fn config [_ cb]
  (let [conform (require :conform)
        condition (fn [_self ctx]
                    (. (vim.fs.find :.prettierrc
                                    {:path ctx.filename
                                     :upward true
                                     :type :file}) 1))]
    (set conform.formatters.prettier {: condition :inherit true})
    (set conform.formatters.prettierd {: condition :inherit true})
    (each [_ f (ipairs ft)]
      (tset conform.formatters_by_ft f [:prettierd :prettier])))
  (cb))

{: ft :lsp [:vtsls :eslint-lsp :oxlint :oxfmt] : config}

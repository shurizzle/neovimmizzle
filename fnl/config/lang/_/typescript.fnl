(local ft [:javascript
           :javascriptreact
           :javascript.jsx
           :typescript
           :typescriptreact
           :typescript.tsx])

(fn config [_ cb]
  (let [conform (require :conform)]
    (each [_ f (ipairs ft)]
      (tset conform.formatters_by_ft f [:prettierd :prettier])))
  (cb))

{: ft :lsp [:typescript-language-server :eslint-lsp] : config}

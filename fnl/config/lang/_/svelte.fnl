(fn config [_ cb]
  (local conform (require :conform))
  (set conform.formatters_by_ft.svelte [[:prettierd :prettier]])
  (cb))

{:lsp [:svelte :eslint-lsp]
 : config}

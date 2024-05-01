(fn init []
  (fn callback []
    ((. (require :lint) :try_lint))
    nil)

  (vim.api.nvim_create_autocmd [:BufWritePost :FileType] {: callback}))

{:lazy true : init :config #(tset (require :lint) :linters_by_ft [])}

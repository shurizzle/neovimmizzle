(fn init []
  (fn callback []
    (let [{: load} (require :lazy.core.loader)
          _ (load [:lint] {:plugin :lint})
          lint (require :lint)]
      (lint.try_lint))
    nil)

  (vim.api.nvim_create_autocmd [:BufWritePost :FileType] {: callback}))

{:lazy true : init :config #(tset (require :lint) :linters_by_ft [])}


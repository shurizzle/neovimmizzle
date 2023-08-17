(fn config []
  ((. (require :crates) :setup) {:null_ls {:enabled true
                                           :name :crates.nvim}})
  (local group (vim.api.nvim_create_augroup :CmpSourceCargo {:clear true}))
  (vim.api.nvim_create_autocmd :BufRead
                               {: group
                                :pattern :Cargo.toml
                                :callback (fn []
                                            ((. (require :cmp) :setup_buffer)
                                             {:sources [{:name :crates}]}))}))

{:event "BufRead Cargo.toml"
 : config}

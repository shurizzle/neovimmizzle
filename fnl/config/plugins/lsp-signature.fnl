(fn init []
  (fn callback [{: buf}]
    ((. (require :lsp_signature) :on_attach) {:floating_window_above_cur_line true
                                              :floating_window true
                                              :transparency 10}
                                             buf))
  (vim.api.nvim_create_autocmd :LspAttach {: callback}))

{:lazy true
 : init}

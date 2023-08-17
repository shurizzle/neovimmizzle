(fn on-attach [opts]
  ((. (require :lsp_signature) :on_attach) {:floating_window_above_cur_line true
                                            :floating_window true
                                            :transparency 10}
                                           opts.buf))

{:lazy true
 :init (fn [] (vim.api.nvim_create_autocmd :LspAttach {:callback on-attach}))}

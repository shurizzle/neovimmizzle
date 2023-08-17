(fn init []
  (fn callback [opts]
    (-?> (vim.lsp.get_client_by_id opts.data.client_id)
         ((. (require :lsp-inlayhints) :on_attach) opts.buf false)))
  (vim.api.nvim_create_autocmd :LspAttach {: callback}))

{:lazy true
 : init
 :config (fn [] ((. (require :lsp-inlayhints) :setup) []))}

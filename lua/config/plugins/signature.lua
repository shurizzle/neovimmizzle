local _M = {}

_M.module_pattern = {
  '^lsp_signature$',
  '^lsp_signature%.',
}

_M.opt = true

function _M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(opts)
      require('lsp_signature').on_attach({
        floating_window_above_cur_line = true,
        floating_window = true,
        transparency = 10,
      }, opts.buf)
    end,
  })
end

return _M

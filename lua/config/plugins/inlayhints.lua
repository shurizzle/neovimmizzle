local _M = {}

_M.lazy = true

function _M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(opts)
      local client = vim.lsp.get_client_by_id(opts.data.client_id)
      if client then
        require('lsp-inlayhints').on_attach(client, opts.buf, false)
      end
    end,
  })
end

function _M.config() require('lsp-inlayhints').setup({}) end

return _M

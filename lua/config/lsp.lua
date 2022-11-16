local _M = {}

vim.cmd('command! Format lua require("config.lsp").format({ async = true })')
vim.api.nvim_exec(
  [[
augroup lsp_document
  autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float()
  autocmd CursorMoved * lua vim.lsp.buf.clear_references()
  autocmd BufWritePre * lua require('config.lsp').format({ async = false })
augroup END
]],
  false
)

function _M.format(options)
  options = options or {}
  options.bufnr = options.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({
    id = options.id,
    bufnr = options.bufnr,
    name = options.name,
  })

  if options.filter then
    clients = vim.tbl_filter(options.filter, clients)
  end

  clients = vim.tbl_filter(function(client)
    return client.supports_method('textDocument/formatting')
  end, clients)

  if #clients ~= 0 then
    return vim.lsp.buf.format(options)
  end
end

return _M

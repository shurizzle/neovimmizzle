vim.cmd('command! Format lua vim.lsp.buf.formatting()')
vim.api.nvim_exec(
  [[
augroup lsp_document
  autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float()
  autocmd CursorMoved * lua vim.lsp.buf.clear_references()
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
augroup END
]],
  false
)

local M = {}

function M.diagnostics()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope diagnostics bufnr=0 theme=get_dropdown')
  else
    vim.lsp.buf.diagnostics()
  end
end

function M.code_action()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope lsp_code_actions theme=get_dropdown preview=false')
  else
    vim.lsp.buf.code_action()
  end
end

function M.range_code_action()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope lsp_range_code_actions theme=get_dropdown preview=false')
  else
    vim.lsp.buf.range_code_action()
  end
end

function M.references()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope lsp_references theme=get_dropdown')
  else
    vim.lsp.buf.references()
  end
end

return M

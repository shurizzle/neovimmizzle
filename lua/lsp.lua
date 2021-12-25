vim.cmd('command! Format lua vim.lsp.buf.formatting()')
vim.api.nvim_exec(
  [[
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float()
  autocmd CursorHold * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved * lua vim.lsp.buf.clear_references()
  autocmd BufWritePre * lua vim.lsp.buf.formatting()
augroup END
]],
  false
)

local M = {}

function M.set_highlight_colors()
  vim.api.nvim_command('hi def link LspReferenceText CursorLine')
  vim.api.nvim_command('hi def link LspReferenceWrite CursorLine')
  vim.api.nvim_command('hi def link LspReferenceRead CursorLine')
  vim.api.nvim_command('hi def link illuminatedWord CursorLine')
end

M.set_highlight_colors()
vim.api.nvim_exec(
  [[
augroup set_highlight_colors
  au!
  autocmd VimEnter * lua require"config.colors".set_highlight_colors()
  autocmd ColorScheme * lua require"config.colors".set_highlight_colors()
augroup END
]],
  false
)

return M

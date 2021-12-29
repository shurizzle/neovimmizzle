local M = {}

function M.pre()
  vim.g.indent_blankline_filetype_exclude = {
    'dashboard',
    'NvimTree',
    'help',
    'packer',
  }
end

function M.config()
  require('indent_blankline').setup({
    show_current_context = true,
    show_current_context_start = true,
  })
end

return M

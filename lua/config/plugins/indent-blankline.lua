local M = {}

function M.pre()
  require('indent_blankline').setup({
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = {
      'dashboard',
      'NvimTree',
      'help',
      'packer',
      'lsp-installer',
      'rfc',
    },
    buftype_exclude = {
      'terminal',
    },
  })
end

return M

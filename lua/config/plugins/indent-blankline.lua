local M = {}

function M.setup()
  for k, v in pairs({
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
  }) do
    vim.g['indent_blankline_' .. k] = v
  end
end

return M

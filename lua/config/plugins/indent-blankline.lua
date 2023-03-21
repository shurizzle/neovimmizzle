local _M = {}

_M.lazy = false

function _M.config()
  require('indent_blankline').setup({
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = {
      'alpha',
      'dashboard',
      'NvimTree',
      'help',
      'packer',
      'lsp-installer',
      'rfc',
      'DressingInput',
      'mason',
    },
    buftype_exclude = {
      'terminal',
    },
  })
end

return _M

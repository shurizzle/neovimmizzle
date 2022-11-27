local _M = {}

_M.filetypes = {
  'c',
  'cpp',
  'objc',
  'objcpp',
  'cuda',
}

function _M.config() return require('config.lang.lsp').clangd end

return _M

local _M = {}

_M.filetypes = {
  'haskell',
  'lhaskell',
}

function _M.config() return require('config.lang.lsp').hls end

return _M

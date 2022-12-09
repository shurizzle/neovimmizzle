local _M = {}

local Future = require('config.future')

_M.filetypes = {
  'haskell',
  'lhaskell',
}

function _M.config()
  return Future.join({
    require('config.lang.lsp').hls,
    require('config.lang.formatters').fourmolu,
  })
end

return _M

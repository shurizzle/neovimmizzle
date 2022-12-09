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
  }):and_then(function(res)
    if res[1][1] then
      return Future.resolved(res[1][2])
    else
      return Future.rejected(res[1][2])
    end
  end)
end

return _M

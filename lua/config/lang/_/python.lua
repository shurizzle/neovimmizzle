local _M = {}

local Future = require('config.future')

function _M.config()
  return Future.join({
    require('config.lang.lsp').pyright,
    require('config.lang.lsp').ruff,
    require('config.lang.formatters').black,
  }):and_then(function(res)
    if not res[1][1] then return Future.rejected(res[1][2]) end
    if not res[2][1] then return Future.rejected(res[2][2]) end
    if not res[3][1] then return Future.rejected(res[3][2]) end
  end)
end

return _M

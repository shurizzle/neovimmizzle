local _M = {}

local Future = require('config.future')

function _M.config()
  return Future.join({
    require('config.lang.lsp').lua_ls,
    require('config.lang.formatters').stylua,
  }):and_then(function(res)
    if not res[1][1] then return Future.rejected(res[1][2]) end
    if not res[2][1] then return Future.rejected(res[2][2]) end
  end)
end

return _M

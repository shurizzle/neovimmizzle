local _M = {}

function _M.config()
  local Future = require('config.future')

  return Future.join({
    require('config.lang.linters').solhint,
    require('config.lang.lsp').solidity_ls,
  }):and_then(function(res)
    if not res[1][1] then return Future.rejected(res[1][2]) end
    if not res[2][1] then return Future.rejected(res[2][2]) end
  end)
end

return _M

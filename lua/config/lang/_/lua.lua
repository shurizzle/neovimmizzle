local _M = {}

local Future = require('config.future')

function _M.config()
  return Future.join({
    require('config.lang.lsp').sumneko_lua,
    require('config.lang.formatters').stylua,
  })
end

return _M

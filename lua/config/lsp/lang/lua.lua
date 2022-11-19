local _M = {}

local Future = require('config.future')

function _M.config()
  return Future.join({
    require('config.lsp.servers').sumneko_lua,
    require('config.lsp.formatters').stylua,
  })
end

return _M

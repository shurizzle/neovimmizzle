local _M = {}

local Future = require('config.future')

function _M.config()
  return Future.join({
    require('config.plugins.lsp.servers').sumneko_lua,
    require('config.plugins.lsp.formatters').stylua,
  })
end

return _M

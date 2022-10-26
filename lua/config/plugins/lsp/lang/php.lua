local _M = {}

local Future = require('config.future')

function _M.config(cb)
  return Future.join({
    require('config.plugins.lsp.servers').intelephense,
    require('config.plugins.lsp.formatters')['php-cs-fixer'],
  })
end

return _M

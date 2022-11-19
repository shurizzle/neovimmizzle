local _M = {}

local Future = require('config.future')

function _M.config(cb)
  return Future.join({
    require('config.lsp.servers').intelephense,
    require('config.lsp.formatters')['php-cs-fixer'],
  })
end

return _M

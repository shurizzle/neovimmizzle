local _M = {}

local Future = require('config.future')

function _M.config(cb)
  return Future.join({
    require('config.lang.lsp').intelephense,
    require('config.lang.formatters')['php-cs-fixer'],
  })
end

return _M

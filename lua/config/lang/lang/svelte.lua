local _M = {}

local Future = require('config.future')

function _M.config()
  local s = require('config.lang.servers')
  Future.join({
    s.svelte,
    s.eslintd,
    require('config.lang.formatters').prettierd,
  })
end

return _M

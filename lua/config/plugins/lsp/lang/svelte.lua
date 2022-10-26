local _M = {}

local Future = require('config.future')

function _M.config()
  local s = require('config.plugins.lsp.servers')
  Future.join({
    s.svelte,
    s.eslintd,
    require('config.plugins.lsp.formatters').prettierd,
  })
end

return _M

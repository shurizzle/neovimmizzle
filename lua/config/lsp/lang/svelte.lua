local _M = {}

local Future = require('config.future')

function _M.config()
  local s = require('config.lsp.servers')
  Future.join({
    s.svelte,
    s.eslintd,
    require('config.lsp.formatters').prettierd,
  })
end

return _M

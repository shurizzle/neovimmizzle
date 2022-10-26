local _M = {}

function _M.config()
  return require('config.plugins.lsp.servers').taplo
end

return _M

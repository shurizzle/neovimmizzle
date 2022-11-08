local _M = {}

function _M.config()
  return require('config.plugins.lsp.servers').pyright
end

return _M

local _M = {}

function _M.config()
  return require('config.plugins.lsp.formatters').omnisharp
end

return _M

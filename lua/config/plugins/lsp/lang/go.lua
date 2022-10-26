local _M = {}

function _M.config()
  return require('config.plugins.lsp.formatters').gopls
end

return _M

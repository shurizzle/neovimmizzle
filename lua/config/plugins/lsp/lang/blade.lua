local _M = {}

function _M.config()
  return require('config.plugins.lsp.formatters')['blade-formatter']
end

return _M

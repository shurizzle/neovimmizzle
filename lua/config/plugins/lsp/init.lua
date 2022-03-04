local _M = {}

function _M.setup()
  vim.g.lspconfig = 1
end

function _M.config()
  require('config.plugins.lsp.handlers').setup()
end

return _M

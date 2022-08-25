local _M = {}

function _M.config()
  local util = require('config.plugins.lsp.util')
  local lsp = require('lspconfig')

  util.install_upgrade('taplo', function(ok)
    if ok then
      lsp.taplo.setup({})
    end
  end)
end

return _M

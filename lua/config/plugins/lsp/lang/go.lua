local _M = {}

local util = require('config.plugins.lsp.util')
local lsp = require('lspconfig')

function _M.config(cb)
  util.install_upgrade('gopls', function(ok)
    if ok then
      lsp.gopls.setup({})
    end
    cb()
  end)
end

return _M

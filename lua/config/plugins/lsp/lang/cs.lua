local _M = {}

local util = require('config.plugins.lsp.util')
local lsp = require('lspconfig')

function _M.config(cb)
  util.install_upgrade('omnisharp', function(ok)
    if ok then
      lsp.omnisharp.setup({
        cmd = { 'omnisharp' },
      })
    end
    cb()
  end)
end

return _M

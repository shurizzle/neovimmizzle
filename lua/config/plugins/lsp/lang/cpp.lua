local _M = {}

local util = require('config.plugins.lsp.util')
local lsp = require('lspconfig')

_M.filetypes = {
  'c',
  'cpp',
  'objc',
  'objcpp',
  'cuda',
}

function _M.config(cb)
  util.install_upgrade('clangd', function(ok)
    if ok then
      lsp.clangd.setup({})
    end
    cb()
  end)
end

return _M

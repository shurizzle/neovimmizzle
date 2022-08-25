local _M = {}

local util = require('config.plugins.lsp2.util')

function _M.config(cb)
  util.install_upgrade('blade-formatter', function(ok)
    if ok then
      local null_ls = require('null-ls')
      null_ls.register(null_ls.builtins.formatting.blade_formatter)
    end
    cb()
  end)
end

return _M

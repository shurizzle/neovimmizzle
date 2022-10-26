local _M = {}

local installer = nil

function _M.config()
  if not installer then
    local i = require('config.plugins.lsp.installer')
    local Future = require('config.future')
    local util = require('config.plugins.lsp.util')

    installer = Future.join({ i['rust-analyzer'], i['codelldb'] })
      :and_then(function(res)
        if res[1][1] then
          return Future.pcall(util.packer_load, 'rust-tools.nvim')
        else
          return Future.rejected(res[1][2])
        end
      end)
  end

  return installer
end

return _M

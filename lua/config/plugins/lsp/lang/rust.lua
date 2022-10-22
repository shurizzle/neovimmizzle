local _M = {}

function _M.config(cb)
  local util = require('config.plugins.lsp.util')

  util.install_upgrade('rust-analyzer', function(ok)
    if ok then
      util.install_upgrade('codelldb', function(_)
        util.packer_load('rust-tools.nvim')
        cb()
      end)
    end
  end)
end

return _M

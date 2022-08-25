local _M = {}

function _M.config(cb)
  local util = require('config.plugins.lsp2.util')

  util.install_upgrade('rust-analyzer', function(ok)
    if ok then
      util.install_upgrade('codelldb', function(_)
        util.packer_load('rust-tools.nvim')
        util.packer_load('inlay-hints.nvim')

        require('rust-tools').setup({
          tools = {
            autoSetHints = false,
          },
          server = {
            settings = {
              ['rust-analyzer'] = {
                allFeatures = true,
                checkOnSave = {
                  command = 'clippy',
                },
              },
            },
          },
        })

        cb()
      end)
    end
  end)
end

return _M

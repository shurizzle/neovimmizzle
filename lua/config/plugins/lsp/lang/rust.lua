local _M = {}

function _M.config(cb)
  local util = require('config.plugins.lsp.util')

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
            on_attach = function(_, bufnr)
              vim.keymap.set(
                'n',
                '<leader>ca',
                '<cmd>RustCodeAction<CR>',
                { buffer = bufnr, silent = true }
              )

              vim.keymap.set(
                'n',
                'K',
                '<cmd>RustHoverAction<CR>',
                { buffer = bufnr, silent = true }
              )
            end,
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

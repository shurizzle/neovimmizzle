local _M = {}

function _M.config()
  require('rust-tools').setup({
    tools = {
      inlay_hints = {
        auto = true,
      },
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
end

return _M

local _M = {}

function _M.config()
  local codelldb = vim.fn.exepath('codelldb')

  if codelldb == '' then
    ---@diagnostic disable-next-line
    codelldb = nil
  elseif codelldb then
    local ok
    ok, codelldb = pcall(vim.loop.fs_realpath, codelldb)
    if not ok then
      ---@diagnostic disable-next-line
      codelldb = nil
    end
  end

  local adapter = nil
  if codelldb then
    local libext = 'so'
    if jit.os == 'Windows' then
      libext = 'lib'
    elseif jit.os == 'OSX' then
      libext = 'dylib'
    end

    local codelib = join_paths(
      vim.fn.fnamemodify(codelldb, ':h'),
      'extension',
      'lldb',
      'lib',
      'liblldb.' .. libext
    )
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb, codelib)
  end

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
    dap = { adapter = adapter },
  })
end

return _M

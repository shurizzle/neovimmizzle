local _M = {}

local installer = nil

local function get_adapter(package)
  local exe = ''
  local lib = '.so'
  local os = vim.loop.os_uname().sysname
  if os:match('Windows') then
    exe = '.exe'
    lib = '.lib'
  elseif os:match('Darwin') then
    lib = '.dylib'
  end

  local path = package:get_install_path()

  exe = join_paths(path, 'extension', 'adapter', 'codelldb' .. exe)
  lib = join_paths(path, 'extension', 'lldb', 'lib', 'liblldb' .. lib)

  return require('rust-tools.dap').get_codelldb_adapter(exe, lib)
end

function _M.config()
  if not installer then
    local i = require('config.plugins.lsp.installer')
    local Future = require('config.future')
    local util = require('config.plugins.lsp.util')

    installer = Future.join({ i['rust-analyzer'], i['codelldb'] })
      :and_then(function(res)
        if res[1][1] then
          local ok1, res1 = pcall(util.packer_load, 'rust-tools.nvim')

          if not ok1 then print(res1) end

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
            dap = { adapter = res[2][1] and get_adapter(res[2][2]) or nil },
          })

          return Future.resolved(nil)
        else
          return Future.rejected(res[1][2])
        end
      end)
  end

  return installer
end

return _M

local _M = {}

local installer = nil
local platform = require('config.platform')
local path = require('config.path')

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

  local p = package:get_install_path()

  exe = path.join(p, 'extension', 'adapter', 'codelldb' .. exe)
  lib = path.join(p, 'extension', 'lldb', 'lib', 'liblldb' .. lib)

  return require('rust-tools.dap').get_codelldb_adapter(exe, lib)
end

function _M.config()
  if not installer then
    local i = require('config.lang.installer')
    local Future = require('config.future')
    local util = require('config.lang.util')

    if platform.is.win or platform.is.fbsd or platform.is.dfbsd or platform.is.nbsd then
      local function set_sysroot_path()
        local Job = require('plenary.job')

        local f = Future.new(function(resolve, reject)
          Job:new({
            command = 'rustc',
            args = { '--print', 'sysroot' },
            on_exit = function(job, return_val)
              if return_val == 0 then
                vim.schedule(function()
                  path.append(path.join(job:result()[1], 'bin'))
                  resolve(nil)
                end)
              else
                reject(
                  'Command exited with error '
                    .. return_val
                    .. ':\n'
                    .. table.concat(job:stderr_result(), '\n')
                )
              end
            end,
          }):start()
        end)

        f:catch(
          function(err)
            vim.notify(err, vim.log.levels.ERROR, {
              title = 'Rust',
            })
          end
        )

        return f
      end

      if platform.is.win then
        installer = Future.join({ set_sysroot_path(), i.codelldb })
      else
        installer = Future.join({ set_sysroot_path() })
      end
    else
      installer = Future.join({ i['rust-analyzer'], i.codelldb })
    end

    installer = installer:and_then(function(res)
      if res[1][1] then
        require('rust-tools').setup({
          tools = {
            inlay_hints = {
              auto = false,
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
          dap = {
            adapter = res[2] and res[2][1] and get_adapter(res[2][2]) or nil,
          },
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

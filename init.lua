local init_path = debug.getinfo(1, 'S').source:sub(2)
local base_dir = init_path:match('(.*[/\\])'):sub(1, -2)

function _G.inspect(what)
  print(vim.inspect(what))
end

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

function _G.base_dir()
  return base_dir
end

function _G.has(what)
  return vim.fn.has(what) ~= 0
end

function _G.is_ssh()
  local res = not not (
      has('unix') and vim.fn.system('who'):match('%(%d+%.%d+%.%d+%.%d+%)')
    )
  _G.is_ssh = loadstring('return ' .. vim.inspect(res))
  return res
end

_G.path_separator = (has('win16') or has('win32') or has('win64')) and '\\'
  or '/'

function _G.join_paths(...)
  return table.concat({ ... }, _G.path_separator)
end

function _G.executable(what)
  return vim.fn.executable(what) ~= 0
end

function _G.extend(res, ...)
  for _, t in pairs(...) do
    for k, v in pairs(t) do
      res[k] = v
    end
  end

  return res
end

require('config.bootstrap')
require('config.utils')
require('config.colors').setup()
require('config.keymaps')
require('config.options')
require('config.plugins')
require('config.lsp')
require('config.rust')

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
  local res = false

  if has('unix') then
    local function has_ip(str)
      local ip = require('ip')

      for m in str:gmatch('%((.+)%)') do
        if ip.parse(m) then
          return true
        end
      end

      return false
    end
    res = has_ip(vim.fn.system('who'))
  end

  ---@diagnostic disable-next-line
  _G.is_ssh = loadstring('return ' .. vim.inspect(res))
  return res
end

_G.path_separator = vim.loop.os_uname().sysname:match('Windows') and '\\' or '/'

function _G.join_paths(...)
  return table.concat({ ... }, _G.path_separator)
end

function _G.executable(what)
  return vim.fn.executable(what) ~= 0
end

function _G.is_headless()
  local res = vim.tbl_isempty(vim.api.nvim_list_uis())
  ---@diagnostic disable-next-line
  _G.is_headless = loadstring('return ' .. vim.inspect(res))
  return res
end

require('config.bootstrap')
require('config.utils')
require('config.colors').setup()
require('config.keymaps')
require('config.options')
require('config.plugins')
require('config.rust')

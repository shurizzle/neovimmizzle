local path = require('config.path')

function _G.inspect(what) print(vim.inspect(what)) end

if not vim.tbl_contains(vim.opt.rtp:get(), path.init_dir) then
  vim.opt.rtp:append(path.init_dir)
end

function _G.has(what) return vim.fn.has(what) ~= 0 end

_G.osname = (function(os)
  if os:match('Windows') then
    return 'windows'
  elseif os:match('Linux') then
    return 'linux'
  elseif os:match('Darwin') then
    return 'macos'
  else
    return 'unknown'
  end
end)(vim.loop.os_uname().sysname)

_G.directory_separator = _G.osname == 'windows' and '\\' or '/'

_G.path_separator = _G.osname == 'windows' and ';' or ':'

function _G.join_paths(...) return table.concat({ ... }, _G.directory_separator) end

function _G.executable(what) return vim.fn.executable(what) ~= 0 end

require('config.bootstrap')
require('config.utils')
require('config.colors').setup()
require('config.keymaps')
require('config.options')
require('config.winbar').setup()
require('config.plugins')
require('config.rust')
require('config.lang')

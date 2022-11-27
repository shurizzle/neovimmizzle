_G.INIT_DIR = vim.fn.fnamemodify(
  vim.loop.fs_realpath(({ debug.getinfo(1, 'S').source:gsub('^@', '') })[1]),
  ':h'
)

function _G.inspect(what) print(vim.inspect(what)) end

if not vim.tbl_contains(vim.opt.rtp:get(), INIT_DIR) then
  vim.opt.rtp:append(INIT_DIR)
end

function _G.base_dir() return INIT_DIR end

function _G.has(what) return vim.fn.has(what) ~= 0 end

function _G.ssh_remote()
  local function extract(env)
    if env then
      local i = env:find('%s')

      if i then
        local remote = require('ip').parse(env:sub(0, i - 1))
        if remote then return remote end
      end
    end
  end

  local function coalesce_map(map, ...)
    for _, name in ipairs({ ... }) do
      local res = map(name)
      if res then return res end
    end
  end

  local res = coalesce_map(
    function(name) return extract(vim.loop.os_getenv(name)) end,
    'SSH_CLIENT',
    'SSH_CONNECTION'
  )

  ---@diagnostic disable-next-line
  _G.ssh_remote = loadstring('return ' .. vim.inspect(res))
  return res
end

function _G.is_ssh() return _G.ssh_remote() ~= nil end

_G.path_separator = vim.loop.os_uname().sysname:match('Windows') and '\\' or '/'

function _G.join_paths(...) return table.concat({ ... }, _G.path_separator) end

function _G.executable(what) return vim.fn.executable(what) ~= 0 end

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
require('config.winbar').setup()
require('config.plugins')
require('config.rust')
require('config.lang')

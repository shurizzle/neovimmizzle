local path = require('config.path')

function _G.inspect(what) print(vim.inspect(what)) end

if not vim.tbl_contains(vim.opt.rtp:get(), path.init_dir) then
  vim.opt.rtp:append(path.init_dir)
end

function _G.has(what) return vim.fn.has(what) ~= 0 end

function _G.executable(what) return vim.fn.executable(what) ~= 0 end

require('config.bootstrap')
require('config.utils')
require('config.colors').setup()
require('config.keymaps')
require('config.options')
require('config.winbar').setup()
require('config.plugins')
require('config.rust')
require('config.lang').config()

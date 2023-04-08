local _M = {}

_M.lazy = true
_M.dependencies = 'nvim-treesitter/nvim-treesitter'
_M.ft = 'nu'

function _M.build()
  local _ = require('nu')
  local platform = require('config.platform')
  local ts_update = require('nvim-treesitter.install').update({
    with_sync = platform.is.headless,
  })
  ts_update()
end

function _M.config() require('nu').setup({}) end

return _M

local _M = {}

_M.dependencies = 'nvim-treesitter/nvim-treesitter'

_M.ft = 'org'

_M.keys = {
  { mode = 'n', '<leader>oa' },
  { mode = 'n', '<leader>oc' },
}

function _M.build()
  local platform = require('config.platform')
  require('orgmode').setup_ts_grammar()
  local ts_update = require('nvim-treesitter.install').update({
    with_sync = platform.is.headless,
  })
  ts_update()
end

function _M.config()
  local org = require('orgmode')
  org.setup_ts_grammar()
  org.setup({})
end

return _M

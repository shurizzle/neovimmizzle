local _M = {}

_M.dependencies = 'nvim-treesitter/nvim-treesitter'

_M.ft = 'org'

_M.keys = {
  { mode = 'n', '<leader>oa' },
  { mode = 'n', '<leader>oc' },
}

function _M.config()
  local org = require('orgmode')
  org.setup_ts_grammar()
  org.setup({})
end

return _M

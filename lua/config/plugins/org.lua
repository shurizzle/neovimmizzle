local _M = {}

_M.ft = 'org'

_M.keys = {
  { 'n', '<leader>oa' },
  { 'n', '<leader>oc' },
}

_M.module_pattern = {
  '^orgmode$',
  '^orgmode%.',
}

function _M.config()
  local org = require('orgmode')
  org.setup_ts_grammar()
  org.setup({})
end

return _M

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
  require('orgmode').setup({})
end

return _M

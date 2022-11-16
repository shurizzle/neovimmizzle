local _M = {}

_M.ft = 'org'

_M.module = 'orgmode'

function _M.config()
  require('orgmode').setup({})
end

return _M

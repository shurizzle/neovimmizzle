local _M = {}

_M.module = 'illuminate'

function _M.setup()
  require('illuminate').configure({
    filetypes_denylist = { 'NvimTree', 'dashboard', 'alpha' },
  })
end

return _M

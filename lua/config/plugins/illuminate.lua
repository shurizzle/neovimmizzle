local _M = {}

function _M.setup()
  require('illuminate').configure({
    filetypes_denylist = { 'NvimTree', 'dashboard', 'alpha' },
  })
end

return _M

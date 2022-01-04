local _M = {}

function _M.pre()
  vim.g.Illuminate_ftblacklist = { 'NvimTree', 'dashboard' }
end

return _M

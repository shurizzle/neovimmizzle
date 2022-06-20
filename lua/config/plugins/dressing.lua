local _M = {}

function _M.config()
  require('dressing').setup({
    input = {
      insert_only = false,
      winblend = 20,
    },
  })
end

return _M

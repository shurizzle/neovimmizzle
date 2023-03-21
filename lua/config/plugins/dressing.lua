local _M = {}

_M.lazy = false

function _M.config()
  require('dressing').setup({
    input = {
      insert_only = false,
      win_options = {
        winblend = 20,
      },
    },
  })
end

return _M

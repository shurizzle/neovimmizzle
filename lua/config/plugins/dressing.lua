local _M = {}

_M.lazy = true

_M.event = 'VeryLazy'

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

local _M = {}

function _M.config()
  local luasnip = require('luasnip')

  luasnip.config.set_config({
    history = true,
    enable_autosnippets = false,
  })

  -- TODO
end

return _M

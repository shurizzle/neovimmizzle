local _M = {}

_M.lazy = false

function _M.config()
  require('bufferline').setup({
    auto_hide = true,
  })

  local sb = require('config.sidebar')
  local api = require('bufferline.api')

  sb.on_resize(function(width) api.set_offset(width, sb.get_name()) end)

  sb.on_close(function() api.set_offset(0) end)
end

return _M

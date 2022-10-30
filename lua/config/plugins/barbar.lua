local _M = {}

function _M.setup()
  vim.g.bufferline = {
    auto_hide = true,
  }
end

function _M.config()
  local sb = require('config.sidebar')
  local api = require('bufferline.api')

  sb.on_resize(function(width)
    api.set_offset(width, sb.get_name())
  end)

  sb.on_close(function()
    api.set_offset(0)
  end)
end

return _M

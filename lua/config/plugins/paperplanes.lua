local _M = {}

_M.lazy = true

_M.cmd = 'PP'

function _M.config()
  require('paperplanes').setup({
    register = '+',
    provider = 'paste.rs',
  })
end

return _M

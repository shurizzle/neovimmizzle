local _M = {}

_M.lazy = true

function _M.config() require('flutter-tools').setup({}) end

return _M

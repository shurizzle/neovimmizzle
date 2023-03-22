local _M = {}

_M.lazy = true

_M.event = 'VeryLazy'

function _M.config() require('colorizer').setup() end

return _M

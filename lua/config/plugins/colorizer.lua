local _M = {}

_M.lazy = true

_M.event = 'BufRead'

function _M.config() require('colorizer').setup() end

return _M

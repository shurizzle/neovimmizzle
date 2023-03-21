local _M = {}

_M.lazy = true

_M.event = 'VeryLazy'

function _M.config() require('gitsigns').setup() end

return _M

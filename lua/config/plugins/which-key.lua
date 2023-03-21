local _M = {}

_M.lazy = true

_M.event = 'VeryLazy'

function _M.config() require('which-key').setup({}) end

return _M

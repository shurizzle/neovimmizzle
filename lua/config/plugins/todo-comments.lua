local _M = {}

_M.lazy = true

_M.event = 'BufRead'

function _M.config() require('todo-comments').setup({}) end

return _M

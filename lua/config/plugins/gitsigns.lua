local _M = {}

_M.lazy = true

_M.event = 'BufRead'

_M.dependencies = { 'nvim-lua/plenary.nvim' }

function _M.config() require('gitsigns').setup() end

return _M

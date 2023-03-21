local _M = {}

_M.lazy = false

function _M.config() require('null-ls').setup({ debug = false }) end

return _M

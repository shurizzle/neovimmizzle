local _M = {}

function _M.config() return require('config.plugins.lsp.servers').dartls end

return _M

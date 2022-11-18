local _M = {}

function _M.config() return require('config.plugins.lsp.servers').gopls end

return _M

local _M = {}

function _M.config() return require('config.plugins.lsp.servers').jsonls end

return _M

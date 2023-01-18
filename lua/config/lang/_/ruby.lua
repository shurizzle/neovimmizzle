local _M = {}

function _M.config()
  local lsp = require('config.lang.lsp')
  return require('config.future').join({ lsp.ruby_ls, lsp.sorbet })
end

return _M

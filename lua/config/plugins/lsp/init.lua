local M = {}

function M.config()
  require('config.plugins.lsp.handlers').setup()
end

return M

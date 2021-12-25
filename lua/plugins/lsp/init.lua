local M = {}

function M.config()
  require('plugins.lsp.handlers').setup()
end

return M

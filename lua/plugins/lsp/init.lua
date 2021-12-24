local M = {}

function M.setup()
  require('plugins.lsp.handlers').setup()
  -- local nvim_lsp = require('lspconfig')
end

return M

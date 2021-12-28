local M = {}

function M.config()
  require('paperplanes').setup({
    register = '+',
    provider = 'ix.io',
  })
end

return M

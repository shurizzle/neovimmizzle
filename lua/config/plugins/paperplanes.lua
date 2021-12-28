local M = {}

function M.config()
  require('paperplanes').setup({
    register = '+',
    provider = 'paste.rs',
  })
end

return M

local M = {}

function M.config()
  if not is_headless() then
    vim.notify = require('notify')
  end
end

return M

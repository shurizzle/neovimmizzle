local M = {}

function M.config()
  if not is_headless() then
    local notify = require('notify')
    notify.setup({})
    vim.notify = notify
  end
end

return M

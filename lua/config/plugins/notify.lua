local M = {}

function M.config()
  if #vim.api.nvim_list_uis() ~= 0 then
    vim.notify = require('notify')
  end
end

return M

local M = {}

function M.config()
  require('crates').setup({
    null_ls = {
      enabled = true,
      name = 'crates.nvim',
    },
  })
end

return M

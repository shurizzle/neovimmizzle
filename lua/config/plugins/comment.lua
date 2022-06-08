local M = {}

function M.config()
  require('Comment').setup({
    mappings = {
      basic = false,
      extra = false,
      extended = false,
    },
  })

  vim.keymap.set(
    { 'x', 'n' },
    '<leader>c ',
    [[v:count == 0 ? '<CMD>lua require("Comment.api").call("toggle_current_linewise_op")<CR>g@$' : '<CMD>lua require("Comment.api").toggle_linewise_count()<CR>']],
    { noremap = true, silent = true, expr = true }
  )
end

return M

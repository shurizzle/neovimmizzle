local M = {}

function M.config()
  require('Comment').setup({
    mappings = {
      basic = false,
      extra = false,
      extended = false,
    },
  })

  local opts = { noremap = true, silent = true, expr = true }
  for _, t in pairs({ 'v', 'n' }) do
    vim.api.nvim_set_keymap(
      t,
      '<leader>c ',
      [[v:count == 0 ? '<CMD>lua require("Comment.api").call("toggle_current_linewise_op")<CR>g@$' : '<CMD>lua require("Comment.api").toggle_linewise_count()<CR>']],
      opts
    )
  end
end

return M

local M = {}

function M.config()
  require('Comment').setup({
    mappings = {
      basic = false,
      extra = false,
      extended = false,
    },
  })

  local flags = { noremap = true, silent = true, expr = false }

  vim.keymap.set('n', '<leader>c ', function()
    require('Comment.api').call('toggle.linewise.current')
    vim.api.nvim_feedkeys('g@$', 'i', false)
  end, flags)

  vim.keymap.set('x', '<leader>c ', function()
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
      'x',
      false
    )
    require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())
  end, flags)
end

return M

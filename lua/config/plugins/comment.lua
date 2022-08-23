local M = {}

function M.config()
  require('Comment').setup({
    mappings = {
      basic = false,
      extra = false,
      extended = false,
    },
  })

  local keymap = require('which-key')

  keymap.register({
    ['<leader>c<space>'] = {
      function()
        require('Comment.api').call('toggle.linewise.current')
        vim.api.nvim_feedkeys('g@$', 'i', false)
      end,
      'Toggle comments',
    },
  }, { mode = 'n', noremap = true, silent = true, expr = false })

  keymap.register({
    ['<leader>c<space>'] = {
      function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
          'x',
          false
        )
        require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())
      end,
      'Toggle comments',
    },
  }, { mode = 'x', noremap = true, silent = true, expr = false })
end

return M

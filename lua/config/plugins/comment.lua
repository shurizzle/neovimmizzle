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
      '<Plug>(comment_toggle_linewise_current)',
      'Toggle comments',
    },
  }, { mode = 'n', noremap = true, silent = true, expr = false })

  keymap.register({
    ['<leader>c<space>'] = {
      '<Plug>(comment_toggle_linewise_visual)',
      'Toggle comments',
    },
  }, { mode = 'x', noremap = true, silent = true, expr = false })
end

return M

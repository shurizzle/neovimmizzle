local _M = {}

_M.lazy = true

_M.keys = { { mode = 'n', '<leader>c/' }, { mode = 'x', '<leader>c/' } }

function _M.config()
  require('Comment').setup({
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    mappings = {
      basic = false,
      extra = false,
      extended = false,
    },
  })

  local keymap = require('which-key')

  keymap.register({
    ['<leader>c/'] = {
      '<Plug>(comment_toggle_linewise_current)',
      'Toggle comments',
    },
  }, { mode = 'n', noremap = true, silent = true, expr = false })

  keymap.register({
    ['<leader>c/'] = {
      '<Plug>(comment_toggle_linewise_visual)',
      'Toggle comments',
    },
  }, { mode = 'x', noremap = true, silent = true, expr = false })
end

return _M

local _M = {}

_M.cmd = 'Telescope'

function _M.setup()
  require('which-key').register({
    ['<leader>f'] = {
      f = { '<cmd>Telescope find_files<CR>', 'Telescope find files' },
      g = { '<cmd>Telescope live_grep<CR>', 'Telescope live grep' },
      b = { '<cmd>Telescope buffers<CR>', 'Telescope show buffers' },
      h = { '<cmd>Telescope help_tags<CR>', 'Telescope help tags' },
      s = {
        '<cmd>Telescope lsp_document_symbols<CR>',
        'Telescope shopw workspace symbols',
      },
    },
  }, { noremap = true, silent = true, mode = 'n' })
end

function _M.config()
  local ts = require('telescope')

  ts.setup({
    defaults = {
      prompt_prefix = '❯ ',
      selection_caret = '❯ ',
      winblend = 20,
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
    },
  })

  ts.load_extension('fzf')
  ts.load_extension('projects')
  ts.load_extension('ui-select')
  ts.load_extension('notify')
end

return _M

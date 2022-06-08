local M = {}

function M.config()
  local ts = require('telescope')
  local keymap = vim.keymap.set

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

  local opts = { noremap = true, silent = true }
  keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
  keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
  keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
  keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
  keymap('n', '<leader>fs', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
end

return M

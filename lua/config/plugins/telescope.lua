local platform = require('config.platform')

local _M = {}

_M.keys = {
  { mode = 'n', '<leader>ff' },
  { mode = 'n', '<leader>fg' },
  { mode = 'n', '<leader>fb' },
  { mode = 'n', '<leader>fh' },
  { mode = 'n', '<leader>fs' },
}

_M.dependencies = {
  'rcarriga/nvim-notify',
  'ahmedkhalf/project.nvim',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = (platform.is.bsd and not platform.is.macos) and 'gmake' or 'make',
  },
  'nvim-telescope/telescope-ui-select.nvim',
}

_M.cmd = 'Telescope'

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

  for k, v in pairs({
    f = { '<cmd>Telescope find_files<CR>', 'Telescope find files' },
    g = { '<cmd>Telescope live_grep<CR>', 'Telescope live grep' },
    b = { '<cmd>Telescope buffers<CR>', 'Telescope show buffers' },
    h = { '<cmd>Telescope help_tags<CR>', 'Telescope help tags' },
    s = {
      '<cmd>Telescope lsp_document_symbols<CR>',
      'Telescope shopw workspace symbols',
    },
  }) do
    vim.keymap.set(
      'n',
      '<leader>f' .. k,
      v[1],
      { noremap = true, silent = true, desc = v[2] }
    )
  end

  for k, v in pairs({
    wh = {
      '<cmd>Telescope diagnostics theme=get_dropdown<CR>',
      'Show workspace diagnostics',
    },
    ch = {
      '<cmd>Telescope diagnostics bufnr=0 theme=get_dropdown<CR>',
      'Show buffer diagnostics',
    },
    cR = {
      '<cmd>Telescope lsp_references theme=get_dropdown<CR>',
      'Show under-cursor references',
    },
  }) do
    vim.keymap.set(
      'n',
      '<leader>c' .. k,
      v[1],
      { noremap = true, silent = true, desc = v[2] }
    )
  end
end

return _M

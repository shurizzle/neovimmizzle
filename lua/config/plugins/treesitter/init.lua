local _M = {}

_M.lazy = true
_M.event = 'BufReadPre'

_M.dependencies = 'nvim-treesitter/nvim-treesitter-textobjects'

function _M.buid()
  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.prolog = {
    install_info = {
      url = 'https://github.com/Rukiza/tree-sitter-prolog',
      files = { 'src/parser.c' },
      revision = 'ee1c64cc15e96430c51914dfee7ca205159b0586',
    },
    filetype = 'prolog',
  }

  local platform = require('config.platform')
  local ts_update = require('nvim-treesitter.install').update({
    with_sync = platform.is.headless,
  })
  ts_update()
end

function _M.config()
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    sync_install = require('config.platform').is.headless,
    ignore_install = { 'comment' }, -- List of parsers to ignore installing
    autopairs = {
      enable = true,
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { '' }, -- list of language that will be disabled
      additional_vim_regex_highlighting = { 'org' },
    },
    indent = { enable = true, disable = { 'yaml' } },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })

  vim.o.foldenable = false
  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'prolog',
    command = 'setlocal foldenable foldmethod=marker',
  })
end

return _M

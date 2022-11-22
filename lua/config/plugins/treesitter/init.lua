local _M = {}

function _M.config()
  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.prolog = {
    install_info = {
      url = 'https://github.com/shurizzle/tree-sitter-prolog',
      files = { 'src/parser.c' },
      revision = '62951c08e4381c01fc1d37aeeffdaaf1d3248844',
    },
    filetype = 'prolog',
  }

  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    sync_install = is_headless(),
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

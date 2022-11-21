local _M = {}

function _M.config()
  local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
  parser_config.prolog = {
    install_info = {
      url = 'https://github.com/Rukiza/tree-sitter-prolog',
      files = { 'src/parser.c' },
      revision = 'db66ca3f5b80e27a3328a8dcec828df93d7250a6',
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
end

return _M

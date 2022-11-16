local _M = {}

function _M.config()
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

  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
end

return _M

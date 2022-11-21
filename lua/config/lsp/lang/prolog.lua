local _M = {}

function _M.config()
  -- swipl -g 'pack_install(lsp_server).'
  require('lspconfig.configs').prolog_lsp = {
    default_config = {
      cmd = {
        'swipl',
        '-g',
        'use_module(library(lsp_server)).',
        '-g',
        'lsp_server:main',
        '-t',
        'halt',
        '--',
        'stdio',
      },
      filetypes = { 'prolog' },
      root_dir = require('lspconfig.util').root_pattern('pack.pl'),
    },
    docs = {
      description = [[
https://github.com/jamesnvc/prolog_lsp

Prolog Language Server
      ]],
    },
  }
  require('lspconfig').prolog_lsp.setup({})
end

return _M

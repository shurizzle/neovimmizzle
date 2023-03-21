local _M = {}

_M.dependencies = 'nvim-treesitter/nvim-treesitter'

_M.ft = {
  'html',
  'javascript',
  'typescript',
  'javascriptreact',
  'typescriptreact',
  'svelte',
  'vue',
  'tsx',
  'jsx',
  'rescript',
  'xml',
  'php',
  'markdown',
  'glimmer',
  'handlebars',
  'hbs',
}

function _M.config() require('nvim-ts-autotag').setup() end

return _M

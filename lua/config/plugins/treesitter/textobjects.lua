local _M = {}

_M.dependencies = 'nvim-treesitter/nvim-treesitter'

function _M.config()
  require('nvim-treesitter.configs').setup({
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },
  })
end

return _M

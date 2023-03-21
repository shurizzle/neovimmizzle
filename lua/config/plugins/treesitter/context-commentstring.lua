local _M = {}

_M.lazy = true

function _M.config()
  require('nvim-treesitter.configs').setup({
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })
end

return _M

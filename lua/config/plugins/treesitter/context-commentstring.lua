local _M = {}

_M.module_pattern = {
  '^ts_context_commentstring$',
  '^ts_context_commentstring%.',
}

function _M.config()
  require('nvim-treesitter.configs').setup({
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })
end

return _M

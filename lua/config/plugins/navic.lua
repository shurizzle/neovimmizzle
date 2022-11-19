local _M = {}

_M.module_pattern = {
  '^nvim%-navic$',
  '^nvim%-navic%.',
}

function _M.config()
  require('nvim-navic').setup({
    highlight = true,
  })
end

return _M

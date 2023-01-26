local _M = {}

_M.module_pattern = {
  '^lsp%-inlayhints$',
  '^lsp%-inlayhints%.',
}

_M.opt = true

function _M.config() require('lsp-inlayhints').setup({}) end

return _M

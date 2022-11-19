local _M = {}

local Future = require('config.future')

_M.filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
}

function _M.config()
  local s = require('config.lsp.servers')
  Future.join({
    s.tsserver,
    s.eslintd,
    require('config.lsp.formatters').prettierd,
  })
end

return _M

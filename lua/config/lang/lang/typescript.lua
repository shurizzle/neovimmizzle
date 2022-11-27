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
  local s = require('config.lang.servers')
  Future.join({
    s.tsserver,
    s.eslintd,
    require('config.lang.formatters').prettierd,
  })
end

return _M

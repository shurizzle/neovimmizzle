local _M = {}

_M.requires = { 'rafamadriz/friendly-snippets' }

function _M.config()
  local luasnip = require('luasnip')

  luasnip.config.set_config({
    history = true,
    enable_autosnippets = false,
  })

  require('luasnip.loaders.from_vscode').lazy_load()
end

return _M

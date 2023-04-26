local platform = require('config.platform')

local _M = {}

_M.lazy = true

_M.build = ((platform.is.bsd and not platform.is.macos) and 'gmake' or 'make')
  .. ' install_jsregexp'

_M.dependencies = { 'rafamadriz/friendly-snippets' }

function _M.config()
  local luasnip = require('luasnip')

  luasnip.config.set_config({
    history = true,
    enable_autosnippets = false,
  })

  require('luasnip.loaders.from_vscode').lazy_load()
end

return _M

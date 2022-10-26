local _M = {}

function _M.config()
  return require('config.plugins.lsp.formatters').dartls:and_then(function()
    require('config.plugins.lsp.util').packer_load('flutter-tools.nvim')
  end)
end

return _M

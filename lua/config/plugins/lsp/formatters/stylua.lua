return require('config.plugins.lsp.installer').stylua:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.stylua)
end)

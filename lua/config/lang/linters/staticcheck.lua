return require('config.lang.installer').staticcheck:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.diagnostics.staticcheck)
end)

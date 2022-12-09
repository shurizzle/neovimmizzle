return require('config.lang.installer').fourmolu:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.fourmolu)
end)

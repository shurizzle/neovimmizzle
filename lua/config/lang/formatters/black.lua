return require('config.lang.installer').black:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.black)
end)

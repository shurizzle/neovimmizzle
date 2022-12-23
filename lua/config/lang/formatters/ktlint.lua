return require('config.lang.installer').ktlint:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.ktlint)
end)

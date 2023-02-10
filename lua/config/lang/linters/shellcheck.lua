return require('config.lang.installer').shellcheck:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.diagnostics.shellcheck)
end)

return require('config.future').pcall(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.fourmolu)
end)

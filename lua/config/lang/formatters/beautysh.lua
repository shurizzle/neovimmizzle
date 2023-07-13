return require('config.lang.installer').beautysh:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.beautysh.with({
    extra_args = { '-i2' },
  }))
end)

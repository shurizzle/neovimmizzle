return require('config.lang.installer').prettierd:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.prettierd.with({
    extra_filetypes = { 'svelte' },
  }))
end)

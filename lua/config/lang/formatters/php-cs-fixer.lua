return require('config.lang.installer')['php-cs-fixer']:and_then(function()
  local null_ls = require('null-ls')
  null_ls.register(null_ls.builtins.formatting.phpcsfixer.with({
    extra_args = { '--rules=@PSR12,ordered_imports,no_unused_imports' },
  }))
end)

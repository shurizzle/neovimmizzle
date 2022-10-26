return require('config.future').pcall(function()
  require('lspconfig').dartls.setup({})
end)

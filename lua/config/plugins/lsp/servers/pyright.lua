return require('config.plugins.lsp.installer').pyright:and_then(function()
  require('lspconfig').pyright.setup({})
end)

return require('config.plugins.lsp.installer').gopls:and_then(
  function() require('lspconfig').gopls.setup({}) end
)

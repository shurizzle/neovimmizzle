return require('config.lsp.installer').gopls:and_then(
  function() require('lspconfig').gopls.setup({}) end
)

return require('config.lsp.installer').pyright:and_then(
  function() require('lspconfig').pyright.setup({}) end
)

return require('config.lsp.installer').clangd:and_then(
  function() require('lspconfig').clangd.setup({}) end
)

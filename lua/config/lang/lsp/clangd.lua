return require('config.lang.installer').clangd:and_then(
  function() require('lspconfig').clangd.setup({}) end
)

return require('config.lang.installer').zls:and_then(
  function() require('lspconfig').zls.setup({}) end
)

return require('config.lang.installer').gopls:and_then(
  function() require('lspconfig').gopls.setup({}) end
)

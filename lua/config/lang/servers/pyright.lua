return require('config.lang.installer').pyright:and_then(
  function() require('lspconfig').pyright.setup({}) end
)

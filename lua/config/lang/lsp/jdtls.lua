return require('config.lang.installer').jdtls:and_then(
  function() require('lspconfig').jdtls.setup({}) end
)

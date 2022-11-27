return require('config.lang.installer').taplo:and_then(
  function() require('lspconfig').taplo.setup({}) end
)

return require('config.lsp.installer').taplo:and_then(
  function() require('lspconfig').taplo.setup({}) end
)

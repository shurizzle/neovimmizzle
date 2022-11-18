return require('config.plugins.lsp.installer').taplo:and_then(
  function() require('lspconfig').taplo.setup({}) end
)

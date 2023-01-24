return require('config.lang.installer')['html-lsp']:and_then(
  function() require('lspconfig').html.setup({}) end
)

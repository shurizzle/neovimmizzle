return require('config.lang.installer')['ruff-lsp']:and_then(
  function() require('lspconfig').ruff_lsp.setup({}) end
)

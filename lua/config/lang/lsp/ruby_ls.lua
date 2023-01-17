return require('config.lang.installer')['ruby-lsp']:and_then(
  function() require('lspconfig').ruby_ls.setup({}) end
)

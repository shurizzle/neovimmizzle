return require('config.lsp.installer')['typescript-language-server']:and_then(
  function() require('config.lsp.util').packer_load('typescript.nvim') end
)

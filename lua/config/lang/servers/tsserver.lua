return require('config.lang.installer')['typescript-language-server']:and_then(
  function() require('config.lang.util').packer_load('typescript.nvim') end
)

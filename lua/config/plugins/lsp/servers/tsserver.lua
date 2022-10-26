return require('config.plugins.lsp.installer')['typescript-language-server']:and_then(
  function()
    require('config.plugins.lsp.util').packer_load('typescript.nvim')
  end
)

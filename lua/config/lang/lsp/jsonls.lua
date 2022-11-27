return require('config.lang.installer')['json-lsp']:and_then(function()
  require('config.lang.util').packer_load('neodev.nvim')
  require('lspconfig').jsonls.setup({})
end)

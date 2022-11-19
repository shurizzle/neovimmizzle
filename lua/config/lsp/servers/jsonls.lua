return require('config.lsp.installer')['json-lsp']:and_then(function()
  require('config.lsp.util').packer_load('neodev.nvim')
  require('lspconfig').jsonls.setup({})
end)

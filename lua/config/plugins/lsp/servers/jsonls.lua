return require('config.plugins.lsp.installer')['json-lsp']:and_then(function()
  require('config.plugins.lsp.util').packer_load('neodev.nvim')
  require('lspconfig').jsonls.setup({})
end)

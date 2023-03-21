return require('config.lang.installer')['json-lsp']:and_then(function()
  require('lazy.core.loader').load('neodev.nvim', {})
  require('lspconfig').jsonls.setup({})
end)

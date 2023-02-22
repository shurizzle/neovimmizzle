return require('config.lang.installer')['eslint-lsp']:and_then(function()
  require('lspconfig').eslint.setup({
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      format = false,
    },
  })
end)

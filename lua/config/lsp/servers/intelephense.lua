return require('config.lsp.installer').intelephense:and_then(function()
  require('lspconfig').intelephense.setup({
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
end)

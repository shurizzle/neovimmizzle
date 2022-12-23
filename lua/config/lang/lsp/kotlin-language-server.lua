return require('config.lang.installer')['kotlin-language-server']:and_then(
  function()
    return require('lspconfig').kotlin_language_server.setup({
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })
  end
)

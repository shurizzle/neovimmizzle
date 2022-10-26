return require('config.plugins.lsp.installer')['svelte-language-server']:and_then(
  function()
    require('lspconfig').svelte.setup({
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })
  end
)

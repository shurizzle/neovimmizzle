return require('config.plugins.lsp.installer')['lua-language-server']:and_then(
  function()
    require('config.plugins.lsp.util').packer_load('neodev.nvim')

    require('lspconfig').sumneko_lua.setup({
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        Lua = {
          color = {
            mode = 'SemanticEnhanced',
          },
          completion = { callSnippet = 'Both' },
          telemetry = { enable = false },
        },
      },
    })
  end
)

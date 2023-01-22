return require('config.lang.installer')['elixir-ls']:and_then(
  function()
    require('lspconfig').elixirls.setup({

      cmd = { 'elixir-ls' },
    })
  end
)

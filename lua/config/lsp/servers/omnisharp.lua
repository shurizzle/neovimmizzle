return require('config.lsp.installer').omnisharp:and_then(
  function()
    require('lspconfig').omnisharp.setup({
      cmd = { 'omnisharp' },
    })
  end
)

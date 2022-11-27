return require('config.lang.installer').omnisharp:and_then(
  function()
    require('lspconfig').omnisharp.setup({
      cmd = { 'omnisharp' },
    })
  end
)

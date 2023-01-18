return require('config.future').pcall(
  function()
    require('lspconfig').sorbet.setup({
      cmd = { 'bundle', 'exec', 'srb', 'tc', '--lsp' },
    })
  end
)

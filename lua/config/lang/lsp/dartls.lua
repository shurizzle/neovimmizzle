return require('config.future')
  .pcall(require('lspconfig').dartls.setup, {})
  :and_then(
    function() require('lazy.core.loader').load('flutter-tools.nvim', {}) end
  )

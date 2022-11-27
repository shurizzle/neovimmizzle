return require('config.future')
  .pcall(require('lspconfig').dartls.setup, {})
  :and_then(
    function() require('config.lang.util').packer_load('flutter-tools.nvim') end
  )

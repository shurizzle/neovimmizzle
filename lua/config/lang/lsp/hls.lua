return require('config.lang.installer')['haskell-language-server']:and_then(
  function() require('lspconfig').hls.setup({}) end
)

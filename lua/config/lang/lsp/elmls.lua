return require('config.lang.installer')['elm-language-server']:and_then(
  function() require('lspconfig').elmls.setup({}) end
)

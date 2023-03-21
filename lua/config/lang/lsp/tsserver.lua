return require('config.lang.installer')['typescript-language-server']:and_then(
  function() require('lazy.core.loader').load('typescript.nvim', {}) end
)

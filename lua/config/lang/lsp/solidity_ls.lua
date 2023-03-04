return require('config.lang.installer')['solidity-ls']:and_then(
  function()
    require('lspconfig').solidity_ls.setup({
      cmd = { 'solidity-ls', '--stdio' },
      bin = 'solidity-ls',
    })
  end
)

return require('config.lang.installer')['fennel-language-server']:and_then(
  function()
    local lspconfig = require('lspconfig')
    lspconfig.fennel_language_server.setup({
      root_dir = lspconfig.util.root_pattern('fnl'),
      settings = {
        fennel = {
          workspace = {
            library = vim.api.nvim_list_runtime_paths(),
          },
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })
  end
)

return require('config.lang.installer')['fennel-language-server']:and_then(
  function()
    local lspconfig = require('lspconfig')
    local unmangle = require('fennel.compiler')['global-unmangling']
    local globals = { vim = true }
    for key, _ in pairs(_G) do
      globals[unmangle(key)] = true
    end
    globals = vim.tbl_keys(globals)

    lspconfig.fennel_language_server.setup({
      root_dir = lspconfig.util.root_pattern('fnl'),
      settings = {
        fennel = {
          workspace = {
            library = vim.api.nvim_list_runtime_paths(),
          },
          diagnostics = {
            globals = globals,
          },
        },
      },
    })
  end
)

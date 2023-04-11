return require('config.lang.installer')['yaml-language-server']:and_then(
  function()
    require('lspconfig').yamlls.setup({
      settings = {
        yaml = {
          schemas = require('schemastore').json.schemas(),
        },
      },
    })
  end
)

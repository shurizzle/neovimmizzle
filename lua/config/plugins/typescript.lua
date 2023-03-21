local _M = {}

_M.lazy = true

function _M.config()
  require('typescript').setup({
    server = {
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    },
  })
end

return _M

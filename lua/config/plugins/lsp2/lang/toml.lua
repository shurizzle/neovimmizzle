local _M = {}

function _M.config()
  local util = require('config.plugins.lsp2.util')
  local lsp = require('lspconfig')

  util.install_upgrade('taplo', function(ok)
    if ok then
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = cmp_nvim_lsp.update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      lsp.taplo.setup({
        on_attach = function(client, bufnr)
          if client.resolved_capabilities then
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
          end

          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          require('config.plugins.lsp2').on_attach(client, bufnr)
        end,
        capabilities = capabilities,
      })
    end
  end)
end

return _M

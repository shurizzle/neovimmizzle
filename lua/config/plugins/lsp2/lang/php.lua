local _M = {}

local util = require('config.plugins.lsp2.util')
local lsp = require('lspconfig')

local function intelephense(cb)
  util.install_upgrade('intelephense', function(ok)
    if ok then
      lsp.intelephense.setup({
        on_attach = function(client, _)
          if client.resolved_capabilities then
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
          end

          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end
    cb()
  end)
end

local function php_cs_fixer(cb)
  util.install_upgrade('php-cs-fixer', function(ok)
    if ok then
      local null_ls = require('null-ls')
      null_ls.register(null_ls.builtins.formatting.phpcsfixer.with({
        extra_args = { '--rules=@PSR12,ordered_imports,no_unused_imports' },
      }))
    end
    cb()
  end)
end

function _M.config(cb)
  intelephense(function()
    php_cs_fixer(cb)
  end)
end

return _M

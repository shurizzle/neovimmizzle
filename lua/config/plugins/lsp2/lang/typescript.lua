local _M = {}

local util = require('config.plugins.lsp2.util')
local lsp = require('lspconfig')

_M.filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
}

local function tsserver(cb)
  util.install_upgrade('typescript-language-server', function(ok)
    if ok then
      lsp.tsserver.setup({
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

local function eslint(cb)
  util.install_upgrade('eslint-lsp', function(ok)
    if ok then
      lsp.eslint.setup({
        on_attach = function(client, _)
          if client.resolved_capabilities then
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
          end

          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          format = false,
        },
      })
    end
    cb()
  end)
end

local function prettier(cb)
  util.install_upgrade('prettierd', function(ok)
    if ok then
      local null_ls = require('null-ls')
      null_ls.register(null_ls.builtins.formatting.prettierd)
    end
    cb()
  end)
end

function _M.config(cb)
  tsserver(function()
    eslint(function()
      prettier(function()
        util.packer_load('inlay-hints.nvim')
        cb()
      end)
    end)
  end)
end

return _M

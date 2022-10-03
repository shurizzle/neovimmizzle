local _M = {}

local util = require('config.plugins.lsp.util')
local lsp = require('lspconfig')

local function svelte(cb)
  util.install_upgrade('svelte-language-server', function(ok)
    if ok then
      lsp.tsserver.setup({
        on_attach = function(client, _)
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
      null_ls.register(null_ls.builtins.formatting.prettierd.with({
        extra_filetypes = { 'svelte' },
      }))
    end
    cb()
  end)
end

function _M.config(cb)
  svelte(function()
    eslint(function()
      prettier(function()
        util.packer_load('inlay-hints.nvim')
        cb()
      end)
    end)
  end)
end

return _M

local _M = {}

local util = require('config.plugins.lsp.util')
local lsp = require('lspconfig')

local function lsp_configs()
  local library = {}

  local path = vim.split(package.path, ';')

  -- this is the ONLY correct way to setup your path
  table.insert(path, 'lua/?.lua')
  table.insert(path, 'lua/?/init.lua')

  local function add(lib)
    for _, p in pairs(vim.fn.expand(lib, false, true)) do
      p = vim.loop.fs_realpath(p)
      library[p] = true
    end
  end

  -- add runtime
  add('$VIMRUNTIME')

  -- add your config
  add('~/.config/nvim')

  -- add plugins
  -- if you're not using packer, then you might need to change the paths below
  add('~/.local/share/nvim/site/pack/packer/opt/*')
  add('~/.local/share/nvim/site/pack/packer/start/*')

  return {
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    -- delete root from workspace to make sure we don't trigger duplicate warnings
    on_new_config = function(config, root)
      local libs = vim.tbl_deep_extend('force', {}, library)
      libs[root] = nil
      config.settings.Lua.workspace.library = libs
      return config
    end,
    settings = {
      Lua = {
        color = {
          mode = 'SemanticEnhanced',
        },
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = path,
        },
        completion = { callSnippet = 'Both' },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim', 'packer_plugins' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = library,
          maxPreload = 2000,
          preloadFileSize = 50000,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
        hint = { enable = false },
      },
    },
  }
end

local function sumneko(cb)
  util.install_upgrade('lua-language-server', function(ok)
    if ok then
      lsp.sumneko_lua.setup(lsp_configs())
    end
    cb()
  end)
end

local function null_ls(cb)
  util.install_upgrade('stylua', function(ok)
    if ok then
      local nullls = require('null-ls')
      nullls.register(nullls.builtins.formatting.stylua)
    end
    cb()
  end)
end

function _M.config(cb)
  sumneko(function()
    null_ls(cb)
  end)
end

return _M

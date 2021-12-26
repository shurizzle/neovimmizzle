local M = {}

local asked = {}

function M.on_file_open()
  local ft = vim.bo.filetype

  if asked[ft] ~= nil then
    return
  end
  local servers = require('nvim-lsp-installer._generated.filetype_map')[ft]

  if servers == nil then
    return
  end
  local installed = vim.tbl_filter(function(server_name)
    return require('nvim-lsp-installer.servers').is_server_installed(
      server_name
    )
  end, servers)

  if vim.tbl_isempty(installed) then
    asked[ft] = true
    require('nvim-lsp-installer').install_by_filetype(ft)
  end
end

function M.config()
  local lsp_installer = require('nvim-lsp-installer')

  lsp_installer.settings({
    ui = {
      icons = {
        server_installed = '✓',
        server_pending = '➜',
        server_uninstalled = '✗',
      },
    },
  })

  vim.api.nvim_command(
    'autocmd BufWinEnter * lua require\'plugins.lsp.installer\'.on_file_open()'
  )

  lsp_installer.on_server_ready(function(server)
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local capabilities = cmp_nvim_lsp.update_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )

    local opts = {
      on_attach = require('plugins.lsp.handlers').on_attach,
      capabilities = capabilities,
    }

    if server.name == 'sumneko_lua' then
      local sumneko_opts = require('plugins.lsp.settings.sumneko_lua')
      opts = vim.tbl_deep_extend('force', sumneko_opts, opts)
    end

    if server.name == 'rust_analyzer' then
      require('rust-tools').setup({
        tools = {
          inlay_hints = {
            show_parameter_hints = false,
            other_hints_prefix = '‣',
          },
        },
        server = vim.tbl_deep_extend(
          'force',
          server:get_default_options(),
          opts
        ),
      })
      server:attach_buffers()
    else
      server:setup(opts)
    end
  end)
end

return M

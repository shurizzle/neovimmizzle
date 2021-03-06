local M = {}

local ignored_ft = { 'markdown', 'blade' }

local asked = {}

function M.on_file_open()
  local ft = vim.bo.filetype

  if asked[ft] ~= nil then
    return
  end

  local ignore = not vim.tbl_isempty(vim.tbl_filter(function(ift)
    return ift == ft
  end, ignored_ft))

  if ignore then
    asked[ft] = true
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
    'autocmd BufWinEnter * lua require\'config.plugins.lsp.installer\'.on_file_open()'
  )

  lsp_installer.on_server_ready(function(server)
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local capabilities = cmp_nvim_lsp.update_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )

    local opts = {
      on_attach = require('config.plugins.lsp.handlers').on_attach,
      capabilities = capabilities,
    }

    local ok, custom_opts = pcall(
      require,
      'config.plugins.lsp.settings.' .. server.name
    )

    if ok then
      opts = vim.tbl_deep_extend('force', custom_opts, opts)
    end

    if server.name == 'rust_analyzer' then
      local ok, rust_tools = pcall(require, 'rust-tools')
      if ok then
        local sysname = vim.loop.os_uname().sysname:lower()
        local libext = 'so'
        if sysname:match('windows') then
          libext = 'dll'
        elseif sysname:match('darwin') then
          libext = 'dylib'
        end

        local extpath = join_paths(
          vim.fn.expand('~'),
          '.local',
          'share',
          'codelldb'
        )
        local codelldb = join_paths(extpath, 'adapter', 'codelldb')
        local liblldb = join_paths(extpath, 'lldb', 'lib', 'liblldb.' .. libext)
        local dap = {}
        if executable(codelldb) and vim.fn.filereadable(liblldb) ~= 0 then
          dap.adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb,
            liblldb
          )
        end

        rust_tools.setup({
          tools = {
            autoSetHints = false,
          },
          dap = dap,
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
    else
      server:setup(opts)
    end
  end)
end

return M

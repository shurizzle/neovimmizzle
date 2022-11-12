local _M = {}

local base_dir =
  debug.getinfo(1, 'S').source:sub(2):match('(.*[/\\])'):sub(1, -2)

local Future = require('config.future')

local function deferred_config(lang)
  local l = require('config.plugins.lsp.lang.' .. lang)
  local fts = table.concat(l.filetypes or { lang }, ',')
  local function launch()
    local lsputil = require('lspconfig.util')
    local other_matching_configs =
      lsputil.get_other_matching_providers(vim.bo.filetype)

    for _, config in ipairs(other_matching_configs) do
      config.manager.try_add_wrapper(vim.api.nvim_get_current_buf())
    end
  end

  local auname = 'LSP_' .. lang

  vim.api.nvim_create_augroup(auname, { clear = true })
  vim.api.nvim_create_autocmd('Filetype', {
    pattern = fts,
    callback = function()
      Future.pcall(l.config):finally(function()
        pcall(vim.api.nvim_del_augroup_by_name, auname)
        launch()
      end)
    end,
    group = auname,
    desc = 'Configure ' .. lang .. ' LSP',
  })
end

local function config(lang)
  local l = require('config.plugins.lsp.lang.' .. lang)
  if l.setup then
    l.setup()
  else
    deferred_config(lang)
  end
end

function _M.config()
  local signs = {
    { name = 'DiagnosticSignError', text = '' },
    { name = 'DiagnosticSignWarn', text = '' },
    { name = 'DiagnosticSignHint', text = '' },
    { name = 'DiagnosticSignInfo', text = '' },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name,
      { texthl = sign.name, text = sign.text, numhl = '' }
    )
  end

  local diag_config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(diag_config)

  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
    })

  vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = 'rounded',
    })

  require('mason').setup({})

  require('null-ls').setup({ debug = false })

  local lsputil = require('lspconfig.util')

  lsputil.on_setup = lsputil.add_hook_before(lsputil.on_setup, function(cfg)
    local function on_attach(client, bufnr)
      require('lsp_signature').on_attach({
        floating_window_above_cur_line = true,
        floating_window = true,
        transparency = 10,
      }, bufnr)

      if client.server_capabilities.documentSymbolProvider then
        local ok, err = pcall(function()
          require('config.plugins.lsp.util').packer_load('nvim-navic')
          require('nvim-navic').attach(client, bufnr)
        end)

        if not ok then
          vim.notify(err, vim.log.levels.ERROR, { title = 'navic' })
        end
      end
    end

    if cfg.on_attach then
      cfg.on_attach = (function(old)
        return function(client, bufnr)
          old(client, bufnr)
          on_attach(client, bufnr)
        end
      end)(cfg.on_attach)
    else
      cfg.on_attach = on_attach
    end

    cfg.capabilities = vim.tbl_deep_extend(
      'force',
      require('cmp_nvim_lsp').default_capabilities(),
      cfg.capabilities or {}
    )
  end)

  local dir_handle = vim.loop.fs_scandir(join_paths(base_dir, 'lang'))
  while true do
    local item, _ = vim.loop.fs_scandir_next(dir_handle)
    if not item then
      break
    end

    item = item:match('(.+)%.lua')
    if item then
      config(item)
    end
  end
end

return _M

local _M = {}

local util = require('config.plugins.lsp2.util')

local function deferred_config(lang)
  local l = require('config.plugins.lsp2.lang.' .. lang)
  local fts = table.concat(l.filetypes or { lang }, ',')
  local function launch()
    local lsp = require('lspconfig')
    local other_matching_configs =
      lsp.util.get_other_matching_providers(vim.bo.filetype)

    for server, config in ipairs(other_matching_configs) do
      config.launch()
    end
  end

  local init = util.once(l.config, launch)

  vim.api.nvim_create_augroup('LSP_' .. lang, { clear = true })
  vim.api.nvim_create_autocmd('Filetype', {
    pattern = fts,
    callback = function()
      init()
    end,
    group = 'LSP_' .. lang,
    desc = 'Configure ' .. lang .. ' LSP',
  })
end

local function config(lang)
  local l = require('config.plugins.lsp2.lang.' .. lang)
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

  -- TODO: glob on dir
  config('rust')
  config('toml')
  config('lua')
end

function _M.on_attach(client, bufnr)
  require('lsp_signature').on_attach({
    floating_window_above_cur_line = true,
    floating_window = true,
    transparency = 10,
  }, bufnr)
  require('illuminate').on_attach(client)
end

return _M

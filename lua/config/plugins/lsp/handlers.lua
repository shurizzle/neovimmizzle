local M = {}

function M.setup()
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

  local config = {
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

  vim.diagnostic.config(config)

  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
    })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
      border = 'rounded',
    }
  )
end

function M.on_attach(client, bufnr)
  if client.name == 'tsserver' or client.name == 'intelephense' then
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end

  require('lsp_signature').on_attach({
    floating_window_above_cur_line = true,
    floating_window = false,
    transparency = 10,
  }, bufnr)
  vim.g.Illuminate_ftblacklist = { 'NvimTree', 'dashboard' }
  require('illuminate').on_attach(client)
end

return M

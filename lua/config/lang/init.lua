local _M = {}

local base_dir =
  debug.getinfo(1, 'S').source:sub(2):match('(.*[/\\])'):sub(1, -2)

local Future = require('config.future')

local function deferred_config(lang)
  local l = require('config.lang._.' .. lang)
  local fts = table.concat(l.filetypes or { lang }, ',')

  local function launch(bufnr)
    local lsputil = require('lspconfig.util')
    local other_matching_configs = lsputil.get_other_matching_providers(
      vim.api.nvim_buf_get_option(bufnr, 'filetype')
    )

    for _, config in ipairs(other_matching_configs) do
      config.manager.try_add_wrapper(bufnr)
    end
  end

  local auname = 'LSP_' .. lang

  vim.api.nvim_create_augroup(auname, { clear = true })
  vim.api.nvim_create_autocmd('Filetype', {
    pattern = fts,
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      Future.pcall(l.config):finally(function(ok, res)
        if not ok then
          if type(res) ~= 'string' then res = vim.inspect(res) end
          vim.notify(
            lang .. ': ' .. res,
            vim.log.levels.ERROR,
            { title = 'LSP' }
          )
        end
        pcall(vim.api.nvim_del_augroup_by_name, auname)
        launch(bufnr)
      end)
    end,
    group = auname,
    desc = 'Configure ' .. lang .. ' LSP',
  })
end

local function config(lang)
  local l = require('config.lang._.' .. lang)
  if l.setup then
    local ok, res = pcall(l.setup)
    if not ok then
      if type(res) ~= 'string' then res = vim.inspect(res) end
      vim.notify(lang .. ': ' .. res, vim.log.levels.ERROR, { title = 'LSP' })
    else
      local ok1, res1 = pcall(function() return res.finally end)
      if ok1 and type(res1) == 'function' then
        res:finally(function(ok, res)
          if not ok then
            if type(res) ~= 'string' then res = vim.inspect(res) end
            vim.notify(
              lang .. ': ' .. res,
              vim.log.levels.ERROR,
              { title = 'LSP' }
            )
          end
        end)
      end
    end
  else
    deferred_config(lang)
  end
end

function _M.format(options)
  options = options or {}
  options.bufnr = options.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({
    id = options.id,
    bufnr = options.bufnr,
    name = options.name,
  })

  if options.filter then clients = vim.tbl_filter(options.filter, clients) end

  clients = vim.tbl_filter(
    function(client) return client.supports_method('textDocument/formatting') end,
    clients
  )

  options.timeout_ms = options.timeout_ms or 4000

  if #clients ~= 0 then return vim.lsp.buf.format(options) end
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

  vim.api.nvim_create_user_command(
    'Format',
    function() _M.format({ async = true }) end,
    { desc = 'Format buffer' }
  )

  local group = vim.api.nvim_create_augroup('lsp_document', { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    pattern = { '*' },
    callback = function() vim.diagnostic.open_float() end,
    group = group,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    pattern = { '*' },
    callback = function() vim.lsp.buf.clear_references() end,
    group = group,
  })
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = { '*' },
    callback = function() _M.format({ async = false }) end,
    group = group,
  })

  local dir_handle =
    vim.loop.fs_scandir(require('config.path').join(base_dir, '_'))
  while true do
    local item, _ = vim.loop.fs_scandir_next(dir_handle)
    if not item then break end

    item = item:match('(.+)%.lua')
    if item then config(item) end
  end
end

return _M

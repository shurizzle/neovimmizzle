---@module 'config.winbar.lsp'
local _M = {}

local u = require('config.winbar.util')
local s = require('config.winbar.lsp.state')
local t = require('config.winbar.lsp.transport')

local request
local augroup

---@param bufnr number
local function fire_event(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  vim.api.nvim_buf_call(
    bufnr,
    function()
      vim.api.nvim_exec_autocmds('User', {
        pattern = 'NewDocumentSymbols',
      })
    end
  )
end

---@param changedtick number
---@param err ResponseError
---@param data DocumentSymbol[]|nil
---@param info Info
local function handler(changedtick, err, data, info)
  local defer = 0

  xpcall(function()
    if err then
      defer = 750
    elseif data then
      local state = s.get_or_create(info.bufnr)
      state.changedtick = changedtick
      if state:set_data(data) then fire_event(info.bufnr) end
    end
  end, function(err) ---@diagnostic disable-line
    if type(err) ~= 'string' then err = vim.inspect(err) end
    vim.api.nvim_echo({ { err, 'ErrorMsg' } }, true, {})
  end)

  if defer ~= 0 then
    ---@diagnostic disable-next-line
    vim.defer_fn(function() request(info.bufnr) end, defer)
  else
    vim.schedule(function() request(info.bufnr) end)
  end
end

---@param bufnr number
---@return boolean|nil
function request(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  local state = s.get_or_create(bufnr)

  if state.requesting then return end
  state.requesting = true

  if u.buf_is_visible(bufnr, 0) then
    local changedtick = vim.api.nvim_buf_get_var(bufnr, 'changedtick')

    if changedtick ~= state.changedtick then
      local ok, id = t.request(bufnr, function(...)
        state.requesting = false
        state.request_id = nil
        handler(changedtick, ...)
      end)

      state.request_id = id
      if not ok then state.requesting = false end
    else
      state.requesting = false
    end
  else
    state.requesting = false
  end
end

---@param bufnr number
---@return boolean|nil
local function delete(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  local state = s.get(bufnr)
  if not state then return end

  if state.request_id then
    local client = state.servers[1]
      and vim.lsp.get_client_by_id(state.servers[1].id)
    if client then client.cancel_request(state.request_id) end
  end

  state.request_id = nil
  state.data = nil
  state.changedtick = 0
  state.requesting = false

  s.delete(bufnr)
end

---@param client table
---@param bufnr number
---@return boolean|nil
local function detach(client, bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  local state = s.get(bufnr)
  if not state then return end

  local id, server = state:remove_server_by_id(client.id)
  if id == 1 and server then
    if server.id == client.id and state.request_id then
      client.cancel_request(state.request_id)
    end

    state.request_id = nil
    state.data = nil
    state.changedtick = 0
    state.requesting = false
    fire_event(bufnr)
  end

  if vim.tbl_isempty(state.servers) then
    s.delete(bufnr)
  else
    request(bufnr)
  end
end

---@param client table
---@param bufnr number
---@return boolean|nil
local function attach(client, bufnr)
  if not client.server_capabilities.documentSymbolProvider then return end
  bufnr = u.ensure_bufnr(bufnr)
  local state = s.get_or_create(bufnr)

  if not state:add_server(client.id, client.name) then return end

  if vim.tbl_count(state.servers) > 1 then
    vim.notify(
      string.format(
        'winbar: Failed to attach to %s(%d) for current buffer. Already attached to %s(%d)',
        client.name,
        client.id,
        state.servers[1].name,
        state.servers[1].id
      ),
      vim.log.levels.WARN
    )
    return
  end

  vim.api.nvim_create_autocmd({
    'BufEnter',
    'BufWritePost',
    'TextChanged',
    'TextChangedI',
    'TextChangedP',
  }, {
    callback = function(opts) return request(opts.buf) end,
    group = augroup,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd('BufWipeout', {
    callback = function(opts) return delete(opts.buf) end,
    group = augroup,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(opts)
      local c = vim.lsp.get_client_by_id(opts.data.client_id)
      if c then detach(c, opts.buf) end
    end,
    group = augroup,
    buffer = bufnr,
  })

  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    request(b)
  end
end

local init = u.call_once(function()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(opts)
      local c = vim.lsp.get_client_by_id(opts.data.client_id)
      if c then return attach(c, opts.buf) end
    end,
  })
  augroup = vim.api.nvim_create_augroup('winbar_lsp', { clear = false })
end)

function _M.setup()
  init()

  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    vim.lsp.for_each_buffer_client(
      b,
      function(client, _, bufnr) return attach(client, bufnr) end
    )
  end
end

---@param bufnr number
---@return DocumentSymbol[]|nil
function _M.get_data(bufnr)
  local state = s.get(bufnr)
  if state then return state.data end
end

return _M

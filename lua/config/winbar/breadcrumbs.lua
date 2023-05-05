local _M = {}

---@class breadcrumbs.Breadcrumb
---@field name string
---@field kind lsp.SymbolKind
---@field range lsp.Range

---@class breadcrumbs.State
---@field cursor lsp.Position
---@field bufnr integer
---@field breadcrumbs breadcrumbs.Breadcrumb[]|nil

---@type table<integer, breadcrumbs.State>
local states = {}
---@type table<integer, string>
local cache = {}

local function fire_event(winid)
  cache[winid] = nil
  pcall(
    vim.api.nvim_win_call,
    winid,
    function()
      vim.api.nvim_exec_autocmds('User', {
        pattern = 'NewBreadcrumbs',
      })
    end
  )
end

local u = require('config.winbar.util')

---@param winid integer
---@return lsp.Position
local function get_cursor(winid)
  winid = u.ensure_winnr(winid)
  local tmp = vim.api.nvim_win_get_cursor(winid)
  return {
    line = tmp[1] - 1,
    character = tmp[2],
  }
end

---@param cursor lsp.Position
---@param range lsp.Range
---@return boolean
local function in_range(cursor, range)
  if
    range.start.line == range['end'].line and range.start.line == cursor.line
  then
    return range.start.character <= cursor.character
      and range['end'].character >= cursor.character
  end

  if range.start.line == cursor.line then
    return range.start.character <= cursor.character
  elseif range['end'].line == cursor.line then
    return range['end'].character >= cursor.character
  elseif range['end'].line > cursor.line and range.start.line < cursor.line then
    return true
  else
    return false
  end
end

---@param cursor lsp.Position
---@param symbols lsp.DocumentSymbol[]|nil
---@return breadcrumbs.Breadcrumb[]|nil
local function extract_breadcrumbs(cursor, symbols)
  local breadcrumbs = {}

  while symbols do
    symbols = (function()
      for _, symbol in ipairs(symbols) do
        if in_range(cursor, symbol.range) then
          table.insert(breadcrumbs, {
            name = symbol.name,
            kind = symbol.kind,
            range = symbol.selectionRange,
          })
          return symbol.children
        end
      end
    end)()
  end

  if #breadcrumbs == 0 then
    return nil
  else
    return breadcrumbs
  end
end

---@param bufnr integer
---@param cursor lsp.Position
---@return breadcrumbs.Breadcrumb[]|nil
local function create_breadcrumbs(bufnr, cursor)
  local symbols = require('config.winbar.lsp').get_data(bufnr)
  if not symbols then return nil end
  return extract_breadcrumbs(cursor, symbols)
end

---@param winid integer
---@param bufnr integer|nil
---@return breadcrumbs.State
local function get_or_create_state(winid, bufnr)
  if not states[winid] then
    local cursor = get_cursor(winid)
    if bufnr == nil then bufnr = vim.api.nvim_win_get_buf(winid) end
    states[winid] = {
      cursor = cursor,
      bufnr = bufnr,
      breadcrumbs = create_breadcrumbs(bufnr, cursor),
    }
    fire_event(winid)
  end
  return states[winid]
end

---@param winid integer
---@return boolean|nil
local function change_cursor(winid)
  local state = get_or_create_state(winid)
  local cursor = get_cursor(winid)
  if vim.deep_equal(state.cursor, cursor) then return end
  state.cursor = cursor
  state.breadcrumbs = create_breadcrumbs(state.bufnr, cursor)
  fire_event(winid)
end

---@param winid integer
---@param bufnr integer
---@return boolean|nil
local function change_buffer(winid, bufnr)
  local state = states[winid]
  if state then
    state.bufnr = bufnr
    state.cursor = {
      line = 1,
      character = 1,
    }
    state.breadcrumbs = create_breadcrumbs(bufnr, state.cursor)
    fire_event(winid)
  else
    get_or_create_state(winid, bufnr)
  end
end

---@param bufnr integer
---@return boolean|nil
local function change_symbols(bufnr)
  for winid, s in pairs(states) do
    if s.bufnr == bufnr then
      s.breadcrumbs = create_breadcrumbs(bufnr, s.cursor)
      fire_event(winid)
    end
  end
end

---@param winnr integer
---@return boolean|nil
local function delete(winnr)
  states[winnr] = nil
  fire_event(winnr)
end

function _M.setup()
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    callback = function() return change_cursor(vim.api.nvim_get_current_win()) end,
  })
  vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    callback = function(opts)
      change_buffer(vim.api.nvim_get_current_win(), opts.buf)
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'NewDocumentSymbols',
    callback = function(opts) return change_symbols(opts.buf) end,
  })
  vim.api.nvim_create_autocmd('WinClosed', {
    callback = function(opts) return delete(tonumber(opts.match) or 0) end,
  })

  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    get_or_create_state(winid)
  end
end

---@param winid integer|nil
---@return breadcrumbs.Breadcrumb[]|nil
function _M.get(winid)
  winid = u.ensure_winnr(winid or 0)
  local s = states[winid]
  if s then return vim.deepcopy(s.breadcrumbs) end
end

_M.icons = {
  File = '',
  Module = '',
  Namespace = '',
  Package = '',
  Class = '',
  Method = '',
  Property = '',
  Field = '',
  Constructor = '',
  Enum = '',
  Interface = '',
  Function = '',
  Variable = '',
  Constant = '',
  String = '',
  Number = '',
  Boolean = '',
  Array = '',
  Object = '',
  Key = '',
  Null = '󰟢',
  EnumMember = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

---@param data breadcrumbs.Breadcrumb
---@param i integer
---@return string
local function render_breadcrumb(data, i)
  local kind_symbol = '?'
  local kind_name = require('config.winbar.lsp.transport').SymbolKind[data.kind]
  if kind_name then kind_symbol = _M.icons[kind_name] end

  local res
  if kind_name then
    res = '%#BreadcrumbIcon' .. kind_name .. '#'
  else
    if i ~= 0 then res = '%#BreadcrumbsBar#' end
  end

  res = res .. u.stl_escape(kind_symbol)

  ---@type string|nil
  local name = data.name
  if name then name = vim.trim(name) end
  if name and string.len(name) > 0 then
    res = res .. ' %#BreadcrumbText#' .. u.stl_escape(name)
  end
  if string.len(res) > 0 then
    res = '%' .. i .. '@GoToDocumentSymbol@' .. res .. '%X'
  end

  return res
end

---@param data breadcrumbs.Breadcrumb[]|nil
---@return string
local function render_breadcrumbs(data)
  if not data then return '' end
  local res = ''
  for index, value in ipairs(data) do
    if #res > 0 then res = res .. '%#BreadcrumbsSeparator# > ' end
    res = res .. render_breadcrumb(value, index)
  end

  if #res > 0 then res = '%#BreadcrumbsBar#' .. res .. '%*' end

  return res
end

---@param winid integer|nil
---@return string
function _M.render(winid)
  winid = u.ensure_winnr(winid or 0)

  if not cache[winid] then
    local s = states[winid]
    if s then
      cache[winid] = render_breadcrumbs(s.breadcrumbs)
    else
      cache[winid] = ''
    end
  end

  return cache[winid]
end

---@param i integer
---@param mouse integer|nil
function _M.jump(i, _, mouse)
  if mouse ~= 'l' then return end
  local winid = u.ensure_winnr(0)
  local symbols = _M.get(winid)
  if not symbols then return end
  local symbol = symbols[i]
  if not symbol then return end
  vim.api.nvim_win_set_cursor(winid, {
    symbol.range.start.line + 1,
    symbol.range.start.character,
  })
end

return _M

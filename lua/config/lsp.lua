vim.cmd('command! Format lua vim.lsp.buf.formatting()')
vim.api.nvim_exec(
  [[
augroup lsp_document
  autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float()
  autocmd CursorMoved * lua vim.lsp.buf.clear_references()
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
augroup END
]],
  false
)

local _M = {}

local function get_lspconfig_available()
  local ok, configs = pcall(require, 'lspconfig.configs')
  local res = {}
  if ok then
    for name, _ in pairs(configs) do
      table.insert(res, name)
    end
  end

  return res
end

local function get_lsp_installer_available()
  local ok, servers = pcall(require, 'nvim-lsp-installer.servers')
  if ok then
    return servers.get_installed_server_names()
  end
  return {}
end

_G.completion = _G.completion or {}
_G.completion.lsp = {}

---@param s string
---@return string
local function trim(s)
  local n = s:find('%S')
  return n and s:match('.*%S', n) or ''
end

---@param str string
---@param sep string|nil
---@return string[]
local function split(str, sep)
  sep = sep or ' '
  local fields = {}
  local pattern = string.format('([^%s]+)', sep)
  _ = str:gsub(pattern, function(c)
    if #c > 0 then
      table.insert(fields, c)
    end
  end)
  return fields
end

local function split2(str, sep)
  local start, stop = string.find(str, sep, 1, true)
  if start and stop then
    local first = string.sub(str, 1, start - 1)
    local second = string.sub(str, start + 1)
    if #second < 1 then
      second = nil
    end
    return first, second
  end
  return str, nil
end

local function split_cmdline(cmd_line, cursor_pos)
  local start, stop = cursor_pos, cursor_pos

  for i = (cursor_pos + 1), #cmd_line do
    stop = i
    if string.sub(cmd_line, i, i) == ' ' then
      break
    end
  end

  local i = cursor_pos - 1
  while i > 0 and i < #cmd_line do
    start = i
    if string.sub(cmd_line, i, i) == ' ' then
      break
    end
    i = i - 1
  end

  local pre = trim(string.sub(cmd_line, 1, start - 1))
  local completing = string.sub(cmd_line, start, stop)
  local post = trim(string.sub(cmd_line, stop + 1))

  if #completing < 1 then
    completing = nil
  end

  return (pre .. ' ' .. post), completing
end

local function create_matcher(obj)
  return setmetatable(obj, {
    __index = function(self, key)
      local meta = getmetatable(self)
      if meta[key] ~= nil then
        return meta[key]
      end
      return self[key]
    end,
    match = function(self, lsp_client)
      if not self[1] or self[1] == lsp_client.id then
        return not self[2] or self[2] == lsp_client.name
      end

      return false
    end,
  })
end

local function concat_matcher(obj)
  return setmetatable(obj, {
    __index = function(self, key)
      local meta = getmetatable(self)
      if meta[key] ~= nil then
        return meta[key]
      end
      return self[key]
    end,
    match = function(self, lsp_client)
      for _, matcher in ipairs(self) do
        if matcher:match(lsp_client) then
          return true
        end
      end
      return false
    end,
  })
end

local function parse_arg(arg)
  local int = tonumber(arg)
  if arg == tostring(int) then
    return create_matcher({ int, nil })
  end

  local first, second = split2(arg, '-')
  if second then
    local id = tonumber(first)
    if first == tostring(id) then
      return create_matcher({ id, second })
    end
  end

  return create_matcher({ nil, arg })
end

local function split_args(line)
  local res = {}
  local x = split(line)
  for _, arg in ipairs(x) do
    if #arg > 0 then
      arg = parse_arg(arg)
      if arg[2] == 'all' then
        return concat_matcher({ create_matcher({ nil, nil }) })
      end

      table.insert(res, arg)
    end
  end
  return concat_matcher(res)
end

local function remove_command(line)
  return split2(line, ' ')
end

---@return table<string, string>
function _M.get_available()
  local res = {}

  for _, name in ipairs(get_lspconfig_available()) do
    res[name] = 'lspconfig'
  end

  for _, name in ipairs(get_lsp_installer_available()) do
    res[name] = 'lsp-installer'
  end

  return res
end

local function get_running()
  return vim.tbl_filter(function(x)
    return x.name ~= 'null-ls'
  end, vim.lsp.get_active_clients())
end

---@param _ string
---@param cmd_line string
---@param cursor_pos number
_G.completion.lsp.stop = function(_, cmd_line, cursor_pos)
  local args, _ --[[completing]] = split_cmdline(cmd_line, cursor_pos + 1)
  _ --[[command]], args = remove_command(args)
  args = split_args(args or '')
  local clients = vim.tbl_filter(function(x)
    return not args:match(x)
  end, get_running())
  -- TODO: filter by completing
  return vim.tbl_map(function(x)
    return x.id .. '-' .. x.name
  end, clients)
end

_M.commands = {}

_M.commands.LspStop = function(args)
  args = split_args(args)
  for _, client in ipairs(get_running()) do
    if args:match(client) then
      client.stop()
    end
  end
end

_M.commands.LspInfo = require('lspconfig.ui.lspinfo')

function _M.setup()
  vim.api.nvim_command(
    'command! -nargs=+ -complete=customlist,v:lua.completion.lsp.stop LspStop lua require\'config.lsp\'.commands.LspStop(<f-args>)'
  )

  vim.api.nvim_command(
    'command! -nargs=0 LspInfo lua require\'config.lsp\'.commands.LspInfo()'
  )
end

function _M.diagnostics()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope diagnostics bufnr=0 theme=get_dropdown')
  else
    vim.lsp.buf.diagnostics()
  end
end

function _M.code_action()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope lsp_code_actions theme=get_dropdown preview=false')
  else
    vim.lsp.buf.code_action()
  end
end

function _M.range_code_action()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope lsp_range_code_actions theme=get_dropdown preview=false')
  else
    vim.lsp.buf.range_code_action()
  end
end

function _M.references()
  if vim.fn.exists(':Telescope') ~= 0 then
    vim.cmd('Telescope lsp_references theme=get_dropdown')
  else
    vim.lsp.buf.references()
  end
end

return _M

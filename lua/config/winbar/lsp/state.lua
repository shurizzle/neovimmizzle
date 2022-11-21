local _M = {}

---@class winbar.lsp.state.Server
---@field id integer
---@field name string

---@class winbar.lsp.state.State
---@field servers winbar.lsp.state.Server[]
---@field data lsp.DocumentSymbol[]|nil
---@field changedtick integer
---@field requesting boolean
---@field request_id integer|nil
local State = {
  servers = {},
  changedtick = 0,
  requesting = false,
}

---comment
---@return winbar.lsp.state.State
function State:new()
  local o = setmetatable({
    servers = {},
    data = nil,
    changedtick = 0,
    requesting = false,
  }, self)
  self.__index = self
  return o
end

---@param id integer
---@return winbar.lsp.state.Server|nil
function State:get_server_by_id(id)
  for _, s in ipairs(self.servers) do
    if s.id == id then return s end
  end
end

---@param name string
---@return winbar.lsp.state.Server|nil
function State:get_server_by_name(name)
  for _, s in ipairs(self.servers) do
    if s.name == name then return s end
  end
end

---@param id integer
---@return integer|nil
---@return winbar.lsp.state.Server|nil
function State:remove_server_by_id(id)
  local i = (function()
    for i, s in ipairs(self.servers) do
      if s.id == id then return i end
    end
  end)()
  local v = nil
  if i ~= nil then
    v = self.servers[i]
    table.remove(self.servers, i)
  end
  return i, v
end

---@param name string
---@return integer|nil
---@return winbar.lsp.state.Server|nil
function State:remove_server_by_name(name)
  local i = (function()
    for i, s in ipairs(self.servers) do
      if s.name == name then return i end
    end
  end)()
  local v = nil
  if i ~= nil then
    v = self.servers[i]
    table.remove(self.servers, i)
  end
  return i, v
end

---@param id integer
---@param name string
---@return boolean
function State:add_server(id, name)
  if self:get_server_by_id(id) then
    return false
  else
    table.insert(self.servers, { id = id, name = name })
    return true
  end
end

---@return table|nil
function State:get_lsp_client()
  while not vim.tbl_isempty(self.servers) do
    local server = self.servers[1]
    local client = vim.lsp.get_client_by_id(server.id)
    if client then
      return client
    else
      table.remove(self.servers, 1)
    end
  end
end

---@param data lsp.DocumentSymbol[]|nil
---@return boolean
function State:set_data(data)
  if vim.deep_equal(self.data, data) then
    return false
  else
    self.data = data
    return true
  end
end

---@type winbar.lsp.state.State[]
local internal_states = {}

local u = require('config.winbar.util')

---@param bufnr integer
---@return winbar.lsp.state.State|nil
function _M.get(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  return internal_states[bufnr]
end

---@param bufnr integer
---@return winbar.lsp.state.State
function _M.get_or_create(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  internal_states[bufnr] = internal_states[bufnr] or State:new()
  return internal_states[bufnr]
end

---@param bufnr integer
function _M.delete(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  internal_states[bufnr] = nil
end

return _M

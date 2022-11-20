---@module 'config.winbar.lsp.state'
local _M = {}

---@class Server
---@field id number
---@field name string

---@class State
---@field servers Server[]
---@field data DocumentSymbol[]|nil
---@field changedtick number
---@field requesting boolean
---@field request_id number|nil
local State = {
  servers = {},
  changedtick = 0,
  requesting = false,
}

---comment
---@return State
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

---@param id number
---@return Server|nil
function State:get_server_by_id(id)
  for _, s in ipairs(self.servers) do
    if s.id == id then return s end
  end
end

---@param name string
---@return Server|nil
function State:get_server_by_name(name)
  for _, s in ipairs(self.servers) do
    if s.name == name then return s end
  end
end

---@param id number
---@return number|nil
---@return Server|nil
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
---@return number|nil
---@return Server|nil
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

---@param id number
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

---@param data DocumentSymbol[]|nil
---@return boolean
function State:set_data(data)
  if vim.deep_equal(self.data, data) then
    return false
  else
    self.data = data
    return true
  end
end

---@type State[]
local internal_states = {}

local u = require('config.winbar.util')

---@param bufnr number
---@return State|nil
function _M.get(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  return internal_states[bufnr]
end

---@param bufnr number
---@return State
function _M.get_or_create(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  internal_states[bufnr] = internal_states[bufnr] or State:new()
  return internal_states[bufnr]
end

---@param bufnr number
function _M.delete(bufnr)
  bufnr = u.ensure_bufnr(bufnr)
  internal_states[bufnr] = nil
end

return _M

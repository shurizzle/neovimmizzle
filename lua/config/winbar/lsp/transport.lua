local _M = {}

---@alias lsp.SymbolKind
---| 1 # File
---| 2 # Module
---| 3 # Namespace
---| 4 # Package
---| 5 # Class
---| 6 # Method
---| 7 # Property
---| 8 # Field
---| 9 # Constructor
---| 10 # Enum
---| 11 # Interface
---| 12 # Function
---| 13 # Variable
---| 14 # Constant
---| 15 # String
---| 16 # Number
---| 17 # Boolean
---| 18 # Array
---| 19 # Object
---| 20 # Key
---| 21 # Null
---| 22 # EnumMember
---| 23 # Struct
---| 24 # Event
---| 25 # Operator
---| 26 # TypeParameter

---@alias lsp.SymbolTag
---| 1 # Deprecated

---@alias lsp.DocumentUri string

---@class lsp.Location
---@field uri lsp.DocumentUri
---@field range Range

---@class lsp.DocumentSymbol
---@field name string
---@field detail string|nil
---@field kind lsp.SymbolKind
---@field tags lsp.SymbolTag[]|nil
---@field deprecated boolean|nil
---@field range lsp.Range
---@field selectionRange lsp.Range
---@field children lsp.DocumentSymbol[]|nil

---@class lsp.SymbolInformation
---@field name string
---@field kind lsp.SymbolKind
---@field tags lsp.SymbolTag[]|nil
---@field deprecated boolean|nil
---@field location lsp.Location
---@field containerName string|nil

---@class lsp.ResponseError
---@field code integer
---@field message string
---@field data any

---@class vim.lsp.HandlerInfo
---@field bufnr integer
---@field client_id integer
---@field method string
---@field params any

_M.SymbolKind = vim.tbl_add_reverse_lookup({
  File = 1,
  Module = 2,
  Namespace = 3,
  Package = 4,
  Class = 5,
  Method = 6,
  Property = 7,
  Field = 8,
  Constructor = 9,
  Enum = 10,
  Interface = 11,
  Function = 12,
  Variable = 13,
  Constant = 14,
  String = 15,
  Number = 16,
  Boolean = 17,
  Array = 18,
  Object = 19,
  Key = 20,
  Null = 21,
  EnumMember = 22,
  Struct = 23,
  Event = 24,
  Operator = 25,
  TypeParameter = 26,
})

_M.SymbolTag = {
  Deprecated = 1,
}

local u = require('config.winbar.util')
local s = require('config.winbar.lsp.state')

local METHOD = 'textDocument/documentSymbol'

---@param bufnr integer
---@param handler fun(err: lsp.ResponseError, data: lsp.SymbolInformation[], info: vim.lsp.HandlerInfo)
---@return boolean
---@return integer|nil
function _M.request(bufnr, handler)
  bufnr = u.ensure_bufnr(bufnr)

  local state = s.get(bufnr)
  if not state then return false end

  local client = state:get_lsp_client()
  if not client then return false end

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
  }
  return client.request(METHOD, params, handler, bufnr)
end

return _M

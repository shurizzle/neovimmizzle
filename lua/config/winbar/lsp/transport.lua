---@module 'config.winbar.lsp.transport'
local _M = {}

---@alias SymbolKind
---| '1' # File
---| '2' # Module
---| '3' # Namespace
---| '4' # Package
---| '5' # Class
---| '6' # Method
---| '7' # Property
---| '8' # Field
---| '9' # Constructor
---| '10' # Enum
---| '11' # Interface
---| '12' # Function
---| '13' # Variable
---| '14' # Constant
---| '15' # String
---| '16' # Number
---| '17' # Boolean
---| '18' # Array
---| '19' # Object
---| '20' # Key
---| '21' # Null
---| '22' # EnumMember
---| '23' # Struct
---| '24' # Event
---| '25' # Operator
---| '26' # TypeParameter

---@alias SymbolTag
---| '1' # Deprecated

---@alias DocumentUri string

---@class Location
---@field uri DocumentUri
---@field range Range

---@class DocumentSymbol
---@field name string
---@field detail ?string
---@field kind SymbolKind
---@field tags ?SymbolTag[]
---@field deprecated ?boolean
---@field range Range
---@field selectionRange Range
---@filed children ?DocumentSymbol[]

---@class SymbolInformation
---@field name string
---@field kind SymbolKind
---@field tags ?SymbolTag[]
---@field deprecated ?boolean
---@field location Location
---@field containerName ?string

---@class ResponseError
---@field code number
---@field message string
---@field data any

---@class Info
---@field bufnr number
---@field client_id number
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

---@param bufnr number
---@param handler fun(err: ResponseError, data: SymbolInformation[], info: Info)
---@return boolean, number|nil
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

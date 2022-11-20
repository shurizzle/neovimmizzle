---@module 'config.winbar.lsp.util'
local _M = {}

---@param bufnr number
---@return number
function _M.ensure_bufnr(bufnr)
  vim.validate({
    bufnr = { bufnr, 'n' },
  })
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  return bufnr
end

---@param winnr number
---@return number
function _M.ensure_winnr(winnr)
  vim.validate({
    winnr = { winnr, 'n' },
  })
  if winnr == 0 then winnr = vim.api.nvim_get_current_win() end
  return winnr
end

---@param tabnr number
---@return number
function _M.ensure_tabnr(tabnr)
  vim.validate({
    tabnr = { tabnr, 'n' },
  })
  if tabnr == 0 then tabnr = vim.api.nvim_get_current_tabpage() end
  return tabnr
end

---@param bufnr number
---@return number[]
function _M.buf_get_windows(bufnr)
  bufnr = _M.ensure_bufnr(bufnr)
  return vim.tbl_filter(
    function(winnr) return vim.api.nvim_win_get_buf(winnr) == bufnr end,
    vim.api.nvim_list_wins()
  )
end

---@param bufnr number
---@return number[]
function _M.buf_get_tabpages(bufnr)
  return vim.tbl_map(
    function(winnr) return vim.api.nvim_win_get_tabpage(winnr) end,
    _M.buf_get_windows(bufnr)
  )
end

---@param winnr number
---@param tabnr number
---@return boolean
function _M.win_is_visible(winnr, tabnr)
  return vim.api.nvim_win_get_tabpage(winnr) == _M.ensure_tabnr(tabnr)
end

---@param bufnr number
---@param tabnr number
---@return boolean
function _M.buf_is_visible(bufnr, tabnr)
  tabnr = _M.ensure_tabnr(tabnr)
  for _, t in ipairs(_M.buf_get_tabpages(bufnr)) do
    if t == tabnr then return true end
  end
  return false
end

---@param fn function
---@return function
function _M.call_once(fn)
  local called = false
  return function(...)
    if not called then
      called = true

      return fn(...)
    end
  end
end

return _M

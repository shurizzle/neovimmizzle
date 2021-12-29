local M = {}

local closing_filetypes = { 'help', 'NvimTree' }

local state = require('bufferline.state')

local function is_numeric(n)
  if type(n) == 'string' then
    return n == tostring(tonumber(n))
  elseif type(n) == 'number' then
    return true
  else
    return false
  end
end

local function ensure_bufnr(bufnr)
  bufnr = is_numeric(bufnr) and tonumber(bufnr) or nil
  bufnr = bufnr or 0
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  return bufnr
end

local function ensure_winnr(winnr)
  winnr = is_numeric(winnr) and tonumber(winnr) or nil
  winnr = winnr or 0
  if winnr == 0 then
    winnr = vim.api.nvim_get_current_win()
  end
  return winnr
end

local function get_buffer_list()
  return state.get_updated_buffers()
end

local function get_current_tab_buffer_list() end

function M.close_direct(bufnr)
  require('bufferline.state').close_buffer(bufnr)
end

function M.new_empty(bang)
  bang = bang and '!' or ''
  vim.api.nvim_command('enew' .. bang)
  local bufnr = vim.api.nvim_get_current_buf() -- 10
  vim.fn.setbufvar(bufnr, 'empty_buffer', true)
  vim.api.nvim_command('setl noswapfile')
  vim.api.nvim_command('setl bufhidden=wipe')
  vim.api.nvim_command('setl buftype=')
  vim.api.nvim_command('setl nobuflisted')
  vim.api.nvim_command('setl noma')
  vim.api.nvim_command('augroup bbye_empty_buffer')
  vim.api.nvim_command('au! * <buffer>')
  vim.api.nvim_command(
    'au BufWipeout <buffer> lua require"config.navigation".close_direct('
      .. bufnr
      .. ')'
  )
  vim.api.nvim_command('augroup END')
end

local function err(msg)
  vim.api.nvim_echo({ { msg, 'ErrorMsg' } }, false, {})
end

local function delete(action, bang, bufnr)
  if type(bang) ~= 'string' then
    bang = bang and '!' or ''
  end
  bufnr = ensure_bufnr(bufnr)

  local ft = vim.bo[bufnr].ft
  if vim.tbl_contains(closing_filetypes, ft) then
    vim.api.nvim_command('q')
    return
  end

  local is_modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
  local has_confirm = vim.api.nvim_get_option('confirm')

  if is_modified and string.len(bang) < 1 and not has_confirm then
    return err(
      'E89: No write since last change for buffer '
        .. bufnr
        .. ' (add ! to override)'
    )
  end

  if is_modified and string.len(bang) > 0 then
    vim.fn.setbufvar(bufnr, '&bufhidden', 'hide')
  end

  local next_bufnr = nil
  for _, bn in ipairs(get_buffer_list()) do
    if vim.tbl_isempty(vim.fn.getbufinfo(bn)[1].windows) then
      next_bufnr = bn
      break
    end
  end

  if next_bufnr then
    vim.api.nvim_command('buffer' .. bang .. ' ' .. next_bufnr)
  else
    M.new_empty(bang)
  end

  if vim.fn.buflisted(bufnr) then
    vim.api.nvim_command(action .. bang .. ' ' .. bufnr)
  end

  vim.api.nvim_command('doautocmd BufWinEnter')
end

function M.close_buffer(bang, bufnr)
  delete('bdelete', bang, bufnr)
end

function M.close_window(bang, winnr)
  winnr = ensure_winnr(winnr)
end

return M

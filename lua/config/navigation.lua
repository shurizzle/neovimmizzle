local M = {}

local closable_filetypes = { 'help', 'NvimTree' }

local state = require('bufferline.state')

local history = {}

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

local function ensure_tabnr(tabnr)
  tabnr = is_numeric(tabnr) and tonumber(tabnr) or nil
  tabnr = tabnr or 0
  if tabnr == 0 then
    tabnr = vim.api.nvim_get_current_win()
  end
  return tabnr
end

local function index_of(tbl, what)
  for k, v in pairs(tbl) do
    if v == what then
      return k
    end
  end
  return nil
end

local registered = false
function M.register()
  if registered then
    return
  end
  registered = true

  vim.api.nvim_exec(
    [[
augroup navigation_history
  au!
  autocmd BufEnter * lua require'config.navigation'.on_buf_enter()
augroup END
]],
    false
  )
end

function M.on_buf_enter()
  local bufnr = ensure_bufnr()
  history = vim.tbl_filter(function(buf)
    return buf ~= bufnr
  end, history)

  table.insert(history, bufnr)
end

function M.get_buffer_list()
  return state.get_updated_buffers()
end

function M.get_history()
  local buffers = M.get_buffer_list()
  history = vim.tbl_filter(function(buf)
    return vim.tbl_contains(buffers, buf)
  end, history)
  return vim.tbl_deep_extend('force', {}, history)
end

function M.close_direct(bufnr)
  require('bufferline.state').close_buffer(bufnr)
end

function M.new_empty(winnr)
  winnr = ensure_winnr(winnr)

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].bufhidden = 'wipe'
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].modifiable = false
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd('setl buftype=')

    vim.api.nvim_exec(
      string.format(
        [[
augroup bbye_empty_buffer
  au! * <buffer>
  au BufWipeout <buffer> lua require"config.navigation".close_direct(%s)
augroup END
    ]],
        bufnr
      ),
      false
    )
  end)
  vim.b[bufnr].empty_buffer = true
  vim.api.nvim_win_set_buf(winnr, bufnr)
end

local function err(msg)
  vim.api.nvim_echo({ { msg, 'ErrorMsg' } }, false, {})
end

local function buf_get_wins(bufnr)
  bufnr = ensure_bufnr(bufnr)
  return vim.tbl_filter(function(winnr)
    return vim.api.nvim_win_get_buf(winnr) == bufnr
  end, vim.api.nvim_list_wins())
end

local function tab_get_wins(tabnr)
  tabnr = ensure_tabnr(tabnr)
  return vim.api.nvim_tabpage_list_wins(tabnr)
end

function M.close_buffer(bang, bufnr)
  if type(bang) ~= 'string' then
    bang = bang and '!' or ''
  end
  bang = bang == '!'
  bufnr = ensure_bufnr(bufnr)

  local ft = vim.bo[bufnr].ft
  if vim.tbl_contains(closable_filetypes, ft) then
    for _, winnr in ipairs(buf_get_wins(bufnr)) do
      vim.api.nvim_win_close(winnr, { force = true })
    end
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

  for _, winnr in ipairs(buf_get_wins(bufnr)) do
    M.clear_window(winnr)
  end

  if vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  vim.api.nvim_command('doautocmd BufWinEnter')
end

function M.clear_window(winnr)
  winnr = ensure_winnr(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local h = M.get_history()
  local remaining = vim.tbl_filter(function(buf)
    return not vim.tbl_contains(h, buf)
  end, M.get_buffer_list())
  h = vim.tbl_map(function(buf)
    if buf == bufnr then
      return buf
    end
    return vim.tbl_isempty(vim.fn.getbufinfo(buf)[1].windows) and buf or nil
  end, h)
  local base = index_of(h, bufnr)
  if not base then
    return
  end

  local stop = #h - base
  if base > stop then
    stop = base
  end

  local prev = nil
  for x = 1, stop do
    local i = base - x
    if i > 0 and h[i] then
      prev = h[i]
      break
    end
    i = base + x
    if i <= #h and h[i] then
      prev = h[i]
      break
    end
  end

  if not prev and vim.tbl_isempty(remaining) then
    _, prev = next(remaining)
  end

  if prev then
    vim.api.nvim_win_set_buf(winnr, prev)
  else
    M.new_empty(winnr)
  end
end

function M.close_window(bang, winnr, close_if_no_valid_buffers)
  if type(bang) ~= 'string' then
    bang = bang and '!' or ''
  end
  bang = bang == '!'
  winnr = ensure_winnr(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  local ft = vim.bo[bufnr].ft
  if vim.tbl_contains(closable_filetypes, ft) then
    vim.api.nvim_win_close(winnr, { force = true })
    return
  end

  local tabnr = vim.api.nvim_win_get_tabpage(winnr)

  local wins = vim.tbl_filter(function(win)
    return win ~= winnr
  end, tab_get_wins(tabnr))
  local valid_windows = vim.tbl_filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return not vim.tbl_contains(closable_filetypes, vim.bo[buf].ft)
      and vim.tbl_contains(M.get_buffer_list(), buf)
  end, wins)

  if close_if_no_valid_buffers and vim.tbl_isempty(valid_windows) then
    local is_modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
    local has_confirm = vim.api.nvim_get_option('confirm')

    if is_modified and string.len(bang) < 1 and not has_confirm then
      return err(
        'E89: No write since last change for buffer '
          .. bufnr
          .. ' (add ! to override)'
      )
    end

    for _, win in ipairs(wins) do
      vim.api.nvim_win_close(win, { force = true })
    end
    if vim.tbl_count(vim.api.nvim_list_tabpages()) == 1 then
      vim.api.nvim_command('quit')
    else
      vim.api.nvim_command(
        'tabclose ' .. vim.api.nvim_tabpage_get_number(tabnr)
      )
    end
  else
    if vim.tbl_isempty(valid_windows) then
      M.clear_window(winnr)
    else
      vim.api.nvim_win_close(winnr, {})
    end
  end
end

return M

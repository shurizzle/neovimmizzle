local _M = {}

_M.module_pattern = {
  '^nvim%-navic$',
  '^nvim%-navic%.',
}

local winbar = '%{%v:lua.require\'nvim-navic\'.get_location()%}'

local function ensure_bufnr(bufnr)
  vim.validate({
    bufnr = { bufnr, 'n', true },
  })
  bufnr = bufnr or 0
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  return bufnr
end

local function ensure_winnr(winnr)
  vim.validate({
    winnr = { winnr, 'n', true },
  })
  winnr = winnr or 0
  if winnr == 0 then winnr = vim.api.nvim_get_current_win() end
  return winnr
end

local function buf_get_var(bufnr, name)
  local ok, res = pcall(vim.api.nvim_buf_get_var, ensure_bufnr(bufnr), name)
  if not ok then res = nil end
  return res
end

local function is_available(bufnr)
  return buf_get_var(bufnr, 'navic_client_id') ~= nil
end

local function set_winbar(winnr)
  winnr = ensure_winnr(winnr)
  local current = vim.api.nvim_win_get_option(winnr, 'winbar')
  if current == '' or current == nil then
    vim.api.nvim_win_set_option(winnr, 'winbar', winbar)
    vim.api.nvim_win_call(winnr, function() vim.cmd('redrawstatus') end)
  end
end

local function unset_winbar(winnr)
  winnr = ensure_winnr(winnr)
  vim.api.nvim_win_set_option(winnr, 'winbar', nil)
end

local function win_adjust_winbar(winnr)
  winnr = ensure_winnr(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  if vim.api.nvim_buf_is_loaded(bufnr) then
    if is_available(bufnr) then
      set_winbar(winnr)
    else
      unset_winbar(winnr)
    end
  end
end

local function buf_get_wins(bufnr)
  bufnr = ensure_bufnr(bufnr)
  return vim.tbl_filter(
    function(winnr) return vim.api.nvim_win_get_buf(winnr) == bufnr end,
    vim.api.nvim_list_wins()
  )
end

local function buf_adjust_winbar(bufnr)
  bufnr = ensure_bufnr(bufnr)
  if vim.api.nvim_buf_is_loaded(bufnr) then
    local update = is_available(bufnr) and set_winbar or unset_winbar

    for _, winnr in ipairs(buf_get_wins(bufnr)) do
      update(winnr)
    end
  end
end

function _M.config()
  require('nvim-navic').setup({
    highlight = true,
  })

  for _, winnr in ipairs(vim.api.nvim_list_wins()) do
    win_adjust_winbar(winnr)
  end

  vim.opt.winhighlight:append('Winbar:NavicBar')

  local augroup = vim.api.nvim_create_augroup('navic_winbar', { clear = true })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'NavicUpdate',
    callback = function(opts) buf_adjust_winbar(opts.buf) end,
    group = augroup,
  })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    callback = function(opts) buf_adjust_winbar(opts.buf) end,
    group = augroup,
  })
end

return _M

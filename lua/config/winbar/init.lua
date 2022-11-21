local _M = {}

local u = require('config.winbar.util')

local excluded_buftypes = {
  'nofile',
  'help',
}

local excluded_filetypes = {}

local winbar = '%{%v:lua.require\'config.winbar\'()%}'

---@param winid integer|nil
---@return string
function _M.breadcrumbs(winid)
  return require('config.winbar.breadcrumbs').render(winid)
end

---@param bufnr integer
---@return string
function _M.icon(bufnr)
  local ok, icon, color = pcall(function()
    local icons = require('nvim-web-devicons')
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name then return icons.get_icon(vim.fn.fnamemodify(name, ':t')) end
  end)
  local res = ''
  if ok then
    if icon then
      if color then res = res .. '%#' .. color .. '#' end
      res = res .. u.stl_escape(icon)
      if color then res = res .. '%*' end
    end
  end
  return res
end

---@param bufnr integer
---@return string
function _M.name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name ~= nil and name ~= '' then name = vim.fn.fnamemodify(name, ':.') end
  if name then name = u.stl_escape(name) end
  return name or ''
end

function _M.len(str)
  if not str then return 0 end
  return vim.api.nvim_eval_statusline(str, { winid = 0, maxwidth = 0 }).width
end

---@param winid integer|nil
---@return string
function _M.winbar(winid)
  winid = u.ensure_winnr(winid or 0)
  local bufnr = vim.api.nvim_win_get_buf(winid)

  local i = _M.icon(bufnr)
  if _M.len(i) > 0 then i = i .. ' ' end
  local n = _M.breadcrumbs(winid)
  if string.len(n) > 0 then n = ' %#BreadcrumbsSeparator#>%* ' .. n end
  return i .. _M.name(bufnr) .. n
end

local function redrawstatus(winnr)
  vim.schedule(function()
    pcall(vim.api.nvim_win_call, winnr, function() vim.cmd('redrawstatus') end)
  end)
end

local function set_winbar(winnr)
  local current = vim.api.nvim_get_option_value('winbar', {
    scope = 'local',
    win = winnr,
  })
  if current == '' or current == nil then
    vim.api.nvim_set_option_value(
      'winbar',
      winbar,
      { scope = 'local', win = winnr }
    )
    redrawstatus(winnr)
  end
end

local function unset_winbar(winnr)
  local current = vim.api.nvim_get_option_value('winbar', {
    scope = 'local',
    win = winnr,
  })
  if current ~= '' and current ~= nil then
    vim.api.nvim_set_option_value(
      'winbar',
      nil,
      { scope = 'local', win = winnr }
    )
    redrawstatus(winnr)
  end
end

local function buf_get_wins(bufnr)
  return vim.tbl_filter(
    function(winnr) return vim.api.nvim_win_get_buf(winnr) == bufnr end,
    vim.api.nvim_list_wins()
  )
end

local function buf_set_winbar(bufnr)
  for _, winnr in ipairs(buf_get_wins(bufnr)) do
    set_winbar(winnr)
  end
end

local function buf_unset_winbar(bufnr)
  for _, winnr in ipairs(buf_get_wins(bufnr)) do
    unset_winbar(winnr)
  end
end

local function options(opts)
  opts = opts or {}
  opts.buf = opts.buf or vim.api.nvim_get_current_buf()
  opts.buftype = opts.buftype
    or vim.api.nvim_buf_get_option(opts.buf, 'buftype')
    or ''
  opts.filetype = opts.filetype
    or vim.api.nvim_buf_get_option(opts.buf, 'filetype')
    or ''
  opts.name = opts.name or vim.api.nvim_buf_get_name(opts.buf) or ''

  return opts
end

local function buf_changed(opts)
  opts = options(opts)
  if
    vim.tbl_contains(excluded_buftypes, opts.buftype)
    or vim.tbl_contains(excluded_filetypes, opts.filetype)
    or opts.name == ''
  then
    buf_unset_winbar(opts.buf)
  else
    buf_set_winbar(opts.buf)
  end
end

function _M.setup()
  vim.cmd([[
function GoToDocumentSymbol(a, b, c, d)
  call v:lua.require('config.winbar.breadcrumbs').jump(a:a, a:b, a:c, a:d)
endfunction
  ]])

  require('config.winbar.lsp').setup()
  require('config.winbar.breadcrumbs').setup()

  vim.opt.winbar = nil

  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = { 'buftype', 'filetype' },
    callback = function(opts)
      local o = { buf = vim.api.nvim_get_current_buf() }
      local k
      if opts.match == 'buftype' then
        k = 'buftype'
      elseif opts.match == 'filetype' then
        k = 'filetype'
      end

      if k then
        o[k] = vim.v.option_new
        buf_changed(o)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWritePost', 'BufReadPost' }, {
    callback = function(opts) buf_changed({ buf = opts.buf }) end,
  })

  vim.api.nvim_create_autocmd({ 'BufNew' }, {
    callback = function(opts)
      local file = opts.file or ''
      if vim.api.nvim_buf_is_valid(opts.buf) and #file > 0 then
        buf_changed({ buf = opts.buf, name = file })
      end
    end,
  })

  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(winid) then
      local bufnr = vim.api.nvim_win_get_buf(winid)
      if vim.api.nvim_buf_is_valid(bufnr) then
        xpcall(function()
          vim.api.nvim_win_call(
            winid,
            function() buf_changed({ buf = bufnr }) end
          )
        end, function(err)
          if type(err) ~= 'string' then err = vim.inspect(err) end
          vim.api.nvim_echo({ { err, 'ErrorMsg' } }, true, {})
        end)
      end
    end
  end
end

return setmetatable(_M, {
  __call = function(self) return self.winbar() end,
})

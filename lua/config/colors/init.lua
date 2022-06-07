local _M = {}

local resources = {
  foreground = '#eeeeee',
  background = '#282828',
  color0 = '#282828',
  color1 = '#c8213d',
  color2 = '#169C51',
  color3 = '#DAAF19',
  color4 = '#2F90FE',
  color5 = '#C14ABE',
  color6 = '#48C6DB',
  color7 = '#CBCBCB',
  color8 = '#505050',
  color9 = '#C7213D',
  color10 = '#1ef15f',
  color11 = '#FFE300',
  color12 = '#00aeff',
  color13 = '#FF40BE',
  color14 = '#48FFFF',
  color15 = '#FFFFFF',
}

local function get_highlights()
  local res = ''
  for _, value in
    ipairs(
      require('shipwright.transform.lush.to_vimscript')(
        require('config.colors.bluesky')
      )
    )
  do
    res = res .. value .. '\n'
  end
  return res
end

local function compile_terminal_colors()
  local res = 'let g:terminal_color_fg = "'
    .. resources.foreground
    .. '"\n'
    .. 'let g:terminal_color_bg = "'
    .. resources.background
    .. '"\n'

  for i = 0, 15, 1 do
    res = res
      .. 'let g:terminal_color_'
      .. tostring(i)
      .. ' = "'
      .. resources['color' .. tostring(i)]
      .. '"\n'
  end

  return res
end

local function get_theme()
  return 'set background=dark\nhi clear\n'
    .. 'if exists("syntax")\n  syntax reset\nendif\n'
    .. 'let g:colors_name="bluesky"\n\n'
    .. get_highlights()
    .. compile_terminal_colors()
    .. [[
augroup set_highlight_colors
  au!
  autocmd VimEnter * lua require"config.colors".set_highlight_colors()
  autocmd ColorScheme * lua require"config.colors".set_highlight_colors()
augroup END
    ]]
end

local function write_file(file, content)
  local f, err, ok = io.open(file, 'w+b')
  if not f then
    return false, err
  end
  ok, err = f:write(content)

  if not ok then
    return false, err
  end

  f:close()

  return true, nil
end

local function get_colo_file()
  return join_paths(vim.fn.stdpath('config'), 'colors', 'bluesky.vim')
end

local function get_palette()
  local res = {}
  for key, value in pairs(require('config.colors.bluesky.palette')) do
    res[key] = tostring(value)
  end
  return res
end

local function generate_palette()
  local palette = 'return ' .. vim.inspect(get_palette())
  local init_path = debug.getinfo(1, 'S').source:sub(2)
  local base_dir = init_path:match('(.*[/\\])'):sub(1, -2)
  local ok, err = write_file(join_paths(base_dir, 'palette.lua'), palette)
  if not ok then
    error(err)
  end
end

_M.color_sync = function()
  local theme = get_theme()
  local ok, err = write_file(get_colo_file(), theme)
  if not ok then
    error(err)
  end
  generate_palette()
  vim.api.nvim_exec(theme, false)
  vim.cmd('doautocmd ColorScheme')
end

function _M.setup()
  colorscheme('bluesky')
  vim.cmd('command! ColoSync lua require"config.colors".color_sync()<CR>')
end

function _M.set_highlight_colors()
  vim.api.nvim_command('hi def link LspReferenceText CursorLine')
  vim.api.nvim_command('hi def link LspReferenceWrite CursorLine')
  vim.api.nvim_command('hi def link LspReferenceRead CursorLine')
  vim.api.nvim_command('hi def link illuminatedWord CursorLine')
end

return _M

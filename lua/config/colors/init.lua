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

local function set_terminal_colors()
  vim.g.terminal_color_0 = resources.color0
  vim.g.terminal_color_1 = resources.color1
  vim.g.terminal_color_2 = resources.color2
  vim.g.terminal_color_3 = resources.color3
  vim.g.terminal_color_4 = resources.color4
  vim.g.terminal_color_5 = resources.color5
  vim.g.terminal_color_6 = resources.color6
  vim.g.terminal_color_7 = resources.color7
  vim.g.terminal_color_8 = resources.color8
  vim.g.terminal_color_9 = resources.color9
  vim.g.terminal_color_10 = resources.color10
  vim.g.terminal_color_11 = resources.color11
  vim.g.terminal_color_12 = resources.color12
  vim.g.terminal_color_13 = resources.color13
  vim.g.terminal_color_14 = resources.color14
  vim.g.terminal_color_15 = resources.color15
end

function _M.setup()
  vim.opt.background = 'dark'
  vim.cmd('hi clear')
  if vim.fn.exists('syntax') ~= 0 then
    vim.cmd('syntax reset')
  end
  vim.g.colors_name = 'bluesky'
  require('lush')(require('config.colors.bluesky'))
  set_terminal_colors()
end

function _M.set_highlight_colors()
  vim.api.nvim_command('hi def link LspReferenceText CursorLine')
  vim.api.nvim_command('hi def link LspReferenceWrite CursorLine')
  vim.api.nvim_command('hi def link LspReferenceRead CursorLine')
  vim.api.nvim_command('hi def link illuminatedWord CursorLine')
end

_M.set_highlight_colors()
vim.api.nvim_exec(
  [[
augroup set_highlight_colors
  au!
  autocmd VimEnter * lua require"config.colors".set_highlight_colors()
  autocmd ColorScheme * lua require"config.colors".set_highlight_colors()
augroup END
]],
  false
)

return _M

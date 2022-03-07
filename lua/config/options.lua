local font_size = 9
if has('mac') then
  font_size = 11
end

local options = {
  fileencoding = 'UTF-8',
  mouse = 'a',
  smartindent = true,
  swapfile = false,
  undofile = false,
  timeoutlen = 300,
  pumheight = 10,
  backup = false,
  writebackup = false,
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  number = true,
  relativenumber = true,
  wrap = true,
  clipboard = 'unnamedplus',
  list = true,
  listchars = 'tab: ·,trail:×,nbsp:%,eol:·,extends:»,precedes:«',
  secure = true,
  window = 53,
  splitbelow = true,
  splitright = true,
  colorcolumn = '80',
  cursorline = true,
  omnifunc = 'v:lua.vim.lsp.omnifunc',
  guifont = 'Hack Nerd Font Mono:h' .. font_size,
}

vim.g.neovide_cursor_vfx_mode = 'torpedo'

vim.g.terminal_color_0 = '#282828'
vim.g.terminal_color_8 = '#505050'
vim.g.terminal_color_1 = '#c8213d'
vim.g.terminal_color_9 = '#C7213D'
vim.g.terminal_color_2 = '#169C51'
vim.g.terminal_color_10 = '#1ef15f'
vim.g.terminal_color_3 = '#DAAF19'
vim.g.terminal_color_11 = '#FFE300'
vim.g.terminal_color_4 = '#2F6CFF'
vim.g.terminal_color_12 = '#00aeff'
vim.g.terminal_color_5 = '#C14ABE'
vim.g.terminal_color_13 = '#FF40BE'
vim.g.terminal_color_6 = '#48C6DB'
vim.g.terminal_color_14 = '#48FFFF'
vim.g.terminal_color_7 = '#CBCBCB'
vim.g.terminal_color_15 = '#FFFFFF'

if has('win32') then
  options.shell = 'powershell'
  options.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  options.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  options.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  options.shellquote = ''
  options.shellxquote = ''
end

if has('termguicolors') then
  options.termguicolors = true
end

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd([[set nocompatible]])
vim.cmd([[set t_ut=]])
if vim.env.TERM == 'xterm-kitty' then
  vim.cmd([[set t_Co=256]])
end

vim.opt.shortmess:append('c')
vim.opt.fillchars:append('eob: ')

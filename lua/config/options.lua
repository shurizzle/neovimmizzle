local font_size = 9
if has('mac') then
  font_size = 11
end

local options = {
  autoread = true,
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
  laststatus = 3,
  showmode = false,
}

vim.g.neovide_cursor_vfx_mode = 'torpedo'

vim.g.himalaya_mailbox_picker = 'telescope'
vim.g.himalaya_telescope_preview_enabled = true

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

if has('unix') and executable('lemonade') and is_ssh() then
  vim.g.clipboard = {
    name = 'lemonade',
    copy = {
      ['+'] = { 'lemonade', 'copy' },
      ['*'] = { 'lemonade', 'copy' },
    },
    paste = {
      ['+'] = { 'lemonade', 'paste' },
      ['*'] = { 'lemonade', 'paste' },
    },
    cache_enabled = 1,
  }
end

-- Disable provides
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

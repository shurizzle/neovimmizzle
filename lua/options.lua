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
  omnifunc = 'v:lua.vim.lsp.omnifunc',
}

if vim.fn.has('termguicolors') then
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

vim.cmd([[autocmd FileType php set iskeyword+=$]])

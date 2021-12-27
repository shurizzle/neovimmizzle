local install_path = join_paths(
  vim.fn.stdpath('data'),
  'site',
  'pack',
  'packer',
  'start',
  'packer.nvim'
)
vim.g.packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.g.packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Installing packer close and reopen Neovim...')
  vim.cmd([[packadd packer.nvim]])
end

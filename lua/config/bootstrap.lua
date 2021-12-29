local function git_clone(url, dir, callback)
  local install_path = join_paths(
    vim.fn.stdpath('data'),
    'site',
    'pack',
    'packer',
    'start',
    dir
  )

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    callback(vim.fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      url,
      install_path,
    }))
  end
end

git_clone(
  'https://github.com/lewis6991/impatient.nvim',
  'impatient.nvim',
  function(_)
    vim.cmd([[packadd impatient.nvim]])
  end
)

git_clone(
  'https://github.com/wbthomason/packer.nvim',
  'packer.nvim',
  function(res)
    vim.g.packer_bootstrap = res
    print('Installing packer close and reopen Neovim...')
    vim.cmd([[packadd packer.nvim]])
  end
)

require('impatient')

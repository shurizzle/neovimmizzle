local function git_clone(url, dir, callback)
  local install_path =
    join_paths(vim.fn.stdpath('data'), 'site', 'pack', 'packer', 'start', dir)

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      url,
      install_path,
    })
    callback(vim.v.shell_error)
  end
end

git_clone(
  'https://github.com/lewis6991/impatient.nvim',
  'impatient.nvim',
  function(res)
    if res == 0 then vim.cmd([[packadd impatient.nvim]]) end
  end
)

xpcall(
  function() require('impatient') end,
  function(_)
    vim.api.nvim_echo(
      { { 'Error while loading impatient', 'ErrorMsg' } },
      true,
      {}
    )
  end
)

git_clone(
  'https://github.com/wbthomason/packer.nvim',
  'packer.nvim',
  function(res)
    if res == 0 then
      vim.g.packer_bootstrap = true
      vim.cmd([[packadd packer.nvim]])
    end
  end
)

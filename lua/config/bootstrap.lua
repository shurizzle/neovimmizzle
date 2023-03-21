local function git_clone(url, dir, params, callback)
  local install_path =
    require('config.path').join(vim.fn.stdpath('data'), 'lazy', dir)

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    local cmd = { 'git', 'clone' }
    for _, value in ipairs(params) do
      table.insert(cmd, value)
    end
    table.insert(cmd, url)
    table.insert(cmd, install_path)
    vim.fn.system(cmd)

    if vim.v.shell_error == 0 then vim.opt.rtp:prepend(install_path) end
    if callback then callback(vim.v.shell_error) end
  else
    vim.opt.rtp:prepend(install_path)
  end
end

git_clone(
  'https://github.com/lewis6991/impatient.nvim',
  'impatient.nvim',
  { '--depth', '1' }
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
  'https://github.com/folke/lazy.nvim.git',
  'lazy.nvim',
  { '--filter=blob:none', '--branch=stable' }
)

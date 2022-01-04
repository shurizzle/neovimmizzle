local _M = {}

local impl = require('config.bootstrap.impl')

local function dofile(filename)
  local f = assert(loadfile(filename))
  return f()
end

local function git_clone(url, dir, callback)
  local install_path = join_paths(
    vim.fn.stdpath('data'),
    'packer',
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

local function install_bins(bins, cb)
  local _cb = vim.is_callable(cb) and cb or function() end

  local packages = {}
  for _, bin in ipairs(bins) do
    if not executable(bin) then
      local package = impl.map_bin(bin)
      if package then
        packages[package] = true
      else
        _cb(false, 'Cannot find a package for ' .. bin)
        return
      end
    end
  end

  impl.install_packages(vim.tbl_keys(packages), function(ok, msg)
    if not ok then
      _cb(ok, msg)
    end

    for _, bin in ipairs(bins) do
      if not executable(bin) then
        _cb(false, 'Failed to install ' .. bin, 'ErrorMsg')
        return
      end
    end
    _cb(true)
  end)
end

local function start_packer()
  vim.cmd(
    'set packpath+='
      .. vim.fn.fnameescape(join_paths(vim.fn.stdpath('data'), 'packer'))
  )

  git_clone(
    'https://github.com/lewis6991/impatient.nvim',
    'impatient.nvim',
    function(_)
      vim.cmd([[packadd impatient.nvim]])
    end
  )

  require('impatient')

  git_clone(
    'https://github.com/wbthomason/packer.nvim',
    'packer.nvim',
    function(res)
      vim.g.packer_bootstrap = res
      print('Installing packer close and reopen Neovim...')
      vim.cmd([[packadd packer.nvim]])
    end
  )

  vim.cmd('packloadall')

  if not vim.g.packer_bootstrap then
    local compiled = join_paths(vim.fn.stdpath('config'), 'packer_compiled.lua')
    if vim.fn.filereadable(compiled) ~= 0 then
      dofile(compiled)
    end
  end

  require('config.plugins')
end

-- function _M.setup()
--   vim.cmd('au VimEnter * lua require"config.bootstrap".on_vimenter()')
-- end

function _M.setup()
  -- start_packer()
end

install_bins({ 'git', 'gcc', 'make', 'fd', 'rg', 'curl' }, function(ok, msg)
  if ok then
    vim.notify('Packages installed.')
    start_packer()
  else
    vim.notify(msg, 'error')
    vim.api.nvim_echo({ { msg, 'ErrorMsg' } }, true, {})
  end
end)

return _M

local _M = {}

-- Assuming that you are using PowerShell.

vim.cmd([[
let &shell = 'powershell'
let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote= mouse=a clipboard=unnamedplus
]])

-- Unlike unix systems child shell doesn't inherith env vars from the parent one
local get_var_cmd = 'echo $env:%s'

local install_choco_cmd =
  'Start-Process powershell -ArgumentList "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command `"[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(\'https://community.chocolatey.org/install.ps1\'));pause`"" -Verb RunAs -Wait'

local install_packages =
  'Start-Process powershell -ArgumentList "-NoLogo -NoProfile -ExecutionPolicy Bypass -Command `"[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;choco install -y %s;pause`"" -Verb RunAs -Wait'

local binmap = {
  ['git'] = 'git',
  ['gcc'] = 'mingw',
  ['make'] = 'make',
  ['fd'] = 'fd',
  ['rg'] = 'ripgrep',
  ['curl'] = 'curl',
}

local function executable(what)
  local res = vim.fn.executable(what)
  return res and res ~= 0
end

-- @param name environment variable name
-- @return the environment variable value
function _M.get_env_var(name)
  return vim.fn.system(string.format(get_var_cmd, name))
end

function _M.update_env_var(name)
  vim.env[name] = _M.get_env_var(name)
end

function _M.update_env_vars()
  for _, var in ipairs({ 'PATH', 'ChocolateyInstall', 'ChocolateyToolsLocation' }) do
    _M.update_env_var(var)
  end
end

local function install_choco()
  vim.notify('Intalling chocolatey, a PowerShell will open...')
  vim.fn.system(install_choco_cmd)
end

function _M.install_choco(cb)
  local _cb = vim.is_callable(cb) and cb or function() end
  if not executable('choco') then
    _M.update_env_vars()
    if not executable('choco') then
      install_choco()
      _M.update_env_vars()
      local res = executable('choco')
      if not res then
        vim.api.nvim_echo(
          { { 'Failed to install Chocolatey', 'ErrorMsg' } },
          true,
          {}
        )
        _cb(false)
        return
      else
        vim.notify('Chocolatey installed')
      end
    end
  end

  _cb(true)
end

function _M.install_bins(bins, cb)
  local _cb = vim.is_callable(cb) and cb or function() end
  local packages = {}
  for _, bin in ipairs(bins) do
    if not executable(bin) then
      if binmap[bin] then
        packages[binmap[bin]] = true
      else
        vim.api.nvim_echo(
          { { 'Cannot find a package for ' .. bin, 'ErrorMsg' } },
          true,
          {}
        )
        _cb(false)
        return
      end
    end
  end

  packages = table.concat(vim.tbl_keys(packages), ' ')

  if string.len(packages) ~= 0 then
    vim.fn.system(string.format(install_packages, packages))
  end

  _M.update_env_var('PATH')

  for _, bin in ipairs(bins) do
    if not executable(bin) then
      vim.api.nvim_echo(
        { { 'Failed to install ' .. bin, 'ErrorMsg' } },
        true,
        {}
      )
      _cb(false)
      return
    end
  end

  _cb(true)
end

function _M.test()
  _M.install_choco(function(ok)
    _M.install_bins({ 'git', 'gcc', 'make', 'fd', 'rg', 'curl' }, function()
      vim.notify('Okaaaay, let\'s go!')
    end)
  end)
end

return _M

local _M = {}

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
local function get_env_var(name)
  return vim.fn.system(string.format(get_var_cmd, name))
end

local function update_env_var(name)
  vim.env[name] = get_env_var(name)
end

local function update_env_vars()
  for _, var in ipairs({ 'PATH', 'ChocolateyInstall', 'ChocolateyToolsLocation' }) do
    update_env_var(var)
  end
end

local function real_install_choco()
  vim.notify('Intalling chocolatey, a PowerShell will open...')
  vim.fn.system(install_choco_cmd)
end

local function install_choco(cb)
  local _cb = vim.is_callable(cb) and cb or function() end
  if not executable('choco') then
    update_env_vars()
    if not executable('choco') then
      real_install_choco()
      update_env_vars()
      if not executable('choco') then
        _cb(false, 'Failed to install Chocolatey')
        return
      else
        vim.notify('Chocolatey installed')
      end
    end
  end

  _cb(true)
end

function _M.map_bin(bin)
  return binmap[bin]
end

local function real_install_packages(packages, cb)
  local _cb = vim.is_callable(cb) and cb or function() end

  if #packages < 1 then
    _cb(true)
    return
  end

  if type(packages) == 'table' then
    packages = table.concat(packages, ' ')
  end

  vim.fn.system(string.format(install_packages, packages))

  update_env_var('PATH')

  _cb(true)
end

function _M.install_packages(bins, cb)
  local _cb = vim.is_callable(cb) and cb or function() end

  install_choco(function(ok, msg)
    if ok then
      real_install_packages(bins, _cb)
    else
      _cb(ok, msg)
    end
  end)
end

return _M

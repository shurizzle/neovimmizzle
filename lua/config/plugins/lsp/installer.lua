local Future = require('config.future')
local GeneratingMap = require('config.generating_map')

local function do_install(p, version, resolve, reject)
  if version then
    vim.notify(string.format('%s: updating to %s', p.name, version))
  else
    vim.notify(string.format('%s: installing', p.name))
  end

  p:once('install:success', function()
    vim.notify(
      string.format(
        '%s: successfully %s',
        p.name,
        version and 'upgraded' or 'installed'
      )
    )
    resolve()
  end)

  p:once('install:failed', function()
    vim.notify(
      string.format(
        '%s: failed to %s',
        p.name,
        version and 'upgrade' or 'install'
      ),
      'error'
    )

    reject()
  end)

  p:install({ version = version })
end

local function install_or_upgrade(what, resolve, reject)
  local mr = require('mason-registry')
  local p = mr.get_package(what)

  if p:is_installed() then
    p:check_new_version(function(ok, version)
      if ok then
        do_install(p, version.latest_version, resolve, reject)
      else
        if type(version) == 'string' and version:match('is not outdated') then
          vim.notify(string.format('%s: up to date', what))
          resolve()
        else
          vim.notify(string.format('%s: update error', what))
          reject(version)
        end
      end
    end)
  else
    do_install(p, nil, resolve, reject)
  end
end

return GeneratingMap.new(function(name)
  vim.validate({
    name = { name, 's' },
  })
  return Future.new(function(resolve, reject)
    install_or_upgrade(name, resolve, reject)
  end)
end)

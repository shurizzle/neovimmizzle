local Future = require('config.future')
local GeneratingMap = require('config.generating_map')

local function default_timeout()
  local ok, res = pcall(function()
    return require('notify')._config().default_timeout()
  end)

  return ok and res or 5000
end

local function do_install(p, version, resolve, reject)
  local window
  if version then
    window = vim.notify(
      string.format('%s: updating to %s', p.name, version),
      vim.log.levels.INFO,
      {
        title = 'Mason',
        timeout = false,
      }
    )
  else
    window =
      vim.notify(string.format('%s: installing', p.name), vim.log.levels.INFO, {
        title = 'Mason',
        timeout = false,
      })
  end

  p:once('install:success', function()
    vim.notify(
      string.format(
        '%s: successfully %s',
        p.name,
        version and 'upgraded' or 'installed'
      ),
      vim.log.levels.INFO,
      { title = 'Mason', timeout = default_timeout(), replace = window }
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
      vim.log.levels.ERROR,
      { title = 'Mason', timeout = default_timeout(), replace = window }
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
          vim.notify(
            string.format('%s: up to date', what),
            vim.log.levels.INFO,
            { title = 'Mason' }
          )
          resolve()
        else
          vim.notify(
            string.format('%s: update error', what),
            vim.log.levels.INFO,
            { title = 'Mason' }
          )
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

local Future = require('config.future')
local GeneratingMap = require('config.generating_map')

local function do_install(p, version)
  local f = require('config.lang.util').notify_progress(function(notify)
    notify(
      string.format(
        version and '%s: updating to %s' or '%s: installing',
        p.name,
        version
      ),
      vim.log.levels.INFO,
      { title = 'Mason' }
    )
    return Future.new(function(resolve, reject)
      p:once('install:success', function() resolve(p) end)
      p:once('install:failed', reject)
    end)
  end, function(notify, ok)
    local message
    local log

    if ok then
      message = string.format(
        '%s: successfully %s',
        p.name,
        version and 'upgraded' or 'installed'
      )
      log = vim.log.levels.INFO
    else
      message = string.format(
        '%s: failed to %s',
        p.name,
        version and 'upgrade' or 'install'
      )
      log = vim.log.levels.Error
    end

    notify(message, log, { title = 'Mason' })
  end)

  p:install({ version = version })

  return f
end

local function install_or_upgrade(what)
  return Future.pcall(function()
    local mr = require('mason-registry')
    local p = mr.get_package(what)

    if p:is_installed() then
      return Future.new(function(resolve, reject)
        p:check_new_version(function(ok, version)
          if ok then
            do_install(p, version.latest_version):and_then(resolve, reject)
          else
            if
              type(version) == 'string' and version:match('is not outdated')
            then
              resolve(p)
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
      end)
    else
      return do_install(p, nil)
    end
  end)
end

return GeneratingMap.new(function(name)
  vim.validate({
    name = { name, 's' },
  })
  return install_or_upgrade(name)
end)

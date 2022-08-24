local _M = {}

local function do_install(p, version, cb)
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
    vim.defer_fn(function()
      cb(true)
    end, 0)
  end)

  p:once('install:failed', function()
    if version then
      vim.notify(string.format('%s: failed to upgrade', p.name))
      vim.defer_fn(function()
        cb(true)
      end, 0)
    else
      vim.notify(string.format('%s: failed to install', p.name))
      vim.defer_fn(function()
        cb(false)
      end, 0)
    end
  end)

  p:install({ version = version })
end

function _M.install_upgrade(what, cb)
  local mr = require('mason-registry')
  local p = mr.get_package(what)

  if p:is_installed() then
    p:check_new_version(function(ok, version)
      if ok then
        do_install(p, version, cb)
      else
        -- skip
        vim.defer_fn(function()
          cb(true)
        end, 0)
      end
    end)
  else
    do_install(p, nil, cb)
  end
end

function _M.packer_load(what)
  if not packer_plugins[what] or not packer_plugins[what].loaded then
    require('packer').loader(what)
  end
end

function _M.once(fn, ...)
  local done = false
  local args = { ... }

  return function()
    if not done then
      done = true
      fn(unpack(args))
      return true
    else
      return false
    end
  end
end

return _M

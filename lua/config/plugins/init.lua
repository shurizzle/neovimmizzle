local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
})

local function hasupvalues(what)
  if type(what) == 'table' then
    local mt = debug.getmetatable(what)
    if
      type(mt) == 'table'
      and type(mt.__call) == 'function'
      and hasupvalues(mt.__call)
    then
      return true
    end

    for _, value in pairs(what) do
      if hasupvalues(value) then
        return true
      end
    end

    return false
  elseif type(what) == 'function' then
    local name, _ = debug.getupvalue(what, 1)
    return not not name
  else
    return false
  end
end

local function remap(plugin)
  if type(plugin.mod) == 'string' then
    local __mod
    plugin.mod, __mod = nil, plugin.mod
    setmetatable(plugin, {
      __mod = __mod,
      __index = function(table, key)
        local res = rawget(table, key)
        if res then
          return res
        end

        local mod = getmetatable(table).__mod
        res = require('config.plugins.' .. mod)[key]
        -- Do magic because of packer's functions serialization
        if hasupvalues(res) then
          res = load(
            string.format(
              'return function(...) require("config.plugins." .. %s)[%s](...) end',
              vim.inspect(mod),
              vim.inspect(key)
            )
          )()
        end
        rawset(table, key, res)

        return res
      end,
    })
  end

  return plugin
end

local config = {}
for _, plugin in ipairs(require('config.plugins._packages')) do
  table.insert(config, remap(plugin))
end

packer.reset()
packer.use(config)

if vim.g.packer_bootstrap then
  packer.sync()
end

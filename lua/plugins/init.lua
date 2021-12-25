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

local function call_pre(plugin)
  local ok, lib = pcall(require, 'plugins.' .. plugin)
  if ok and type(lib) == 'table' then
    pcall(lib.pre)
  end
end

local function create_callback(plugin, callback)
  local ok, lib = pcall(require, 'plugins.' .. plugin)
  if ok and type(lib) == 'table' then
    if type(lib[callback]) == 'function' then
      return loadstring(
        string.format('return require("plugins.%s").%s()', plugin, callback)
      )
    else
      return lib[callback]
    end
  end
end

local function add_callbacks(plugin, name)
  for orig, callback in pairs({ 'install', 'update', 'run', config = 'setup' }) do
    if type(orig) ~= 'string' then
      orig = callback
    end

    local cb = create_callback(name, callback)
    if cb then
      plugin[orig] = cb
    end
  end

  return plugin
end

local config = {}
for _, plugin in ipairs(require('plugins.packer')) do
  if plugin.name then
    local name = plugin.name
    plugin.name = nil
    plugin = add_callbacks(plugin, name)
    call_pre(name)
  end

  table.insert(config, plugin)
end

packer.startup(function(use)
  for _, plugin in ipairs(config) do
    use(plugin)
  end
  if vim.g.packer_bootstrap then
    require('.packer').sync()
  end
end)

local status_ok, packer = pcall(require, 'packer')
if not status_ok then return end

packer.on_complete = vim.schedule_wrap(function()
  require('config.colors').sync()
  require('orgmode').setup_ts_grammar()
  local ts_update =
    require('nvim-treesitter.install').update({ with_sync = true })
  ts_update()
  vim.cmd([[doautocmd User PackerComplete]])
end)

packer.init({
  display = {
    open_fn = function() return require('packer.util').float({ border = 'rounded' }) end,
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
      if hasupvalues(value) then return true end
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
        if res then return res end

        local mod = getmetatable(table).__mod
        res = require('config.plugins.' .. mod)[key]
        -- Do magic because of packer's functions serialization
        if hasupvalues(res) then
          res = loadstring(
            string.format(
              'return function(...) require(%s)[%s](...) end',
              vim.inspect('config.plugins.' .. mod),
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
for _, plugin in ipairs(require('config.plugins._')) do
  table.insert(config, remap(plugin))
end

table.insert(config, {
  'rktjmp/lush.nvim',
  as = 'lush',
  opt = true,
  cmd = { 'LushRunQuickstart', 'LushRunTutorial', 'Lushify' },
})

table.insert(config, 1, { 'lewis6991/impatient.nvim' })
table.insert(config, 1, { 'wbthomason/packer.nvim' })
table.insert(config, 1, {
  'williamboman/mason.nvim',
  module_pattern = {
    '^mason%-core$',
    '^mason%-core%.',
    '^mason%-registry$',
    '^mason%-registry%.',
    '^mason%-schemas$',
    '^mason%-schemas%.',
    '^mason$',
    '^mason%.',
  },
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonLog',
    'MasonUninstall',
    'MasonUninstallAll',
  },
  config = function() require('mason').setup({}) end,
})

packer.reset()
packer.use(config)

if vim.g.packer_bootstrap then packer.sync() end

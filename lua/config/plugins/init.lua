local after_load = nil
local loaded = false
local function _after_load()
  if not loaded then
    loaded = true
    if after_load then after_load() end
  end
end

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
    local mod = plugin.mod
    plugin.mod = nil
    plugin =
      vim.tbl_deep_extend('force', plugin, require('config.plugins.' .. mod))
  end

  return plugin
end

local config = {}
for _, plugin in ipairs(require('config.plugins._')) do
  table.insert(config, remap(plugin))
end

table.insert(config, {
  'rktjmp/lush.nvim',
  name = 'lush',
  lazy = true,
  cmd = { 'LushRunQuickstart', 'LushRunTutorial', 'Lushify' },
})

if vim.fn.has('nvim-0.9.0') == 0 then
  table.insert(config, 1, { 'lewis6991/impatient.nvim', lazy = false })
end
table.insert(config, 1, { 'rktjmp/hotpot.nvim', lazy = false })
table.insert(config, 1, { 'folke/lazy.nvim', lazy = false })
table.insert(config, 1, {
  'williamboman/mason.nvim',
  lazy = true,
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonLog',
    'MasonUninstall',
    'MasonUninstallAll',
  },
  config = function() require('mason').setup({}) end,
})

require('lazy').setup(config)
_after_load()

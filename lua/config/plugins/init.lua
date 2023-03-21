local after_load = nil
local loaded = false
local function _after_load()
  if not loaded then
    loaded = true
    if after_load then after_load() end
  end
end

-- packer.on_complete = vim.schedule_wrap(function()
--   require('config.colors').sync()
--   require('orgmode').setup_ts_grammar()
--   local ts_update =
--     require('nvim-treesitter.install').update({ with_sync = true })
--   ts_update()
--   _after_load()
--   vim.cmd([[doautocmd User PackerComplete]])
-- end)

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

table.insert(config, 1, { 'lewis6991/impatient.nvim' })
table.insert(config, 1, { 'folke/lazy.nvim' })
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

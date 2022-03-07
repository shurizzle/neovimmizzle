local lush = require('lush')
local cp = require('config.colors.bluesky.palette')

---@diagnostic disable: undefined-global
return lush(function()
  return {
    TelescopeBorder { fg = cp.blue },
    TelescopeMatching { gui = 'italic,underline' },
  }
end)

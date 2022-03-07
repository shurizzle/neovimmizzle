local lush = require('lush')
local cp = require('config.colors.bluesky.palette')

---@diagnostic disable: undefined-global
return lush(function()
  return {
    IndentBlanklineChar { fg = cp.almostblack },
    IndentBlanklineContextChar { fg = cp.white },
  }
end)

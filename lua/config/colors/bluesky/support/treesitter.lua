local lush = require('lush')
local cp = require('config.colors.bluesky.palette')

return lush(function()
  return {
    TSWarning { fg = cp.black, bg = cp.yellow },
    TSDanger { fg = cp.black, bg = cp.red },
  }
end)

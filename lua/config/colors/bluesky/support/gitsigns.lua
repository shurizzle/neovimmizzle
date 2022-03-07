local lush = require('lush')
local cp = require('config.colors.bluesky.palette')

---@diagnostic disable: undefined-global
return lush(function()
  return {
    GitSignsAdd { fg = cp.green },
    GitSignsChange { fg = cp.yellow },
    GitSignsDelete { fg = cp.red },

    GitSignsAddNr { fg = cp.green, bg = cp.black },
    GitSignsChangeNr { fg = cp.yellow, bg = cp.black },
    GitSignsDeleteNr { fg = cp.red, bg = cp.black },

    GitSignsAddLn { fg = cp.green, bg = cp.black },
    GitSignsChangeLn { fg = cp.yellow, bg = cp.black },
    GitSignsDeleteLn { fg = cp.red, bg = cp.black },
  }
end)

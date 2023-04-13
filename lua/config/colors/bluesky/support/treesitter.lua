local lush = require 'lush'
local cp = require 'config.colors.bluesky.palette'

---@diagnostic disable: undefined-global
return lush(function(injected_functions)
  local sym = injected_functions.sym

  return {
    TSWarning { fg = cp.black, bg = cp.yellow },
    TSDanger { fg = cp.black, bg = cp.red },
    sym '@embedded' { fg = cp.white },
  }
end)

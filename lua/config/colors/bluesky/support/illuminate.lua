local lush = require 'lush'
local cp = require 'config.colors.bluesky.palette'

---@diagnostic disable: undefined-global
return lush(
  function()
    return {
      IlluminatedWordText { gui = 'underline' },
      illuminateWordRead { IlluminatedWordText },
      illuminateWordWrite { IlluminatedWordText },
    }
  end
)

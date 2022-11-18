local lush = require 'lush'
local cp = require 'config.colors.bluesky.palette'

---@diagnostic disable: undefined-global
return lush(
  function()
    return {
      BufferCurrent { bg = cp.grey, fg = cp.white },
      BufferCurrentIndex { BufferCurrent },
      BufferCurrentMod { bg = cp.grey, fg = cp.yellow },
      BufferCurrentSign { bg = cp.grey, fg = cp.blue },
      BufferCurrentTarget { bg = cp.grey, fg = cp.red },
      BufferVisible { bg = cp.almostblack, fg = cp.white },
      BufferVisibleIndex { BufferVisible },
      BufferVisibleMod { bg = cp.almostblack, fg = cp.yellow },
      BufferVisibleSign { bg = cp.almostblack, fg = cp.blue },
      BufferVisibleTarget { bg = cp.almostblack, fg = cp.red },
      BufferInactive { bg = cp.black, fg = cp.grey },
      BufferInactiveIndex { BufferInactive },
      BufferInactiveMod { bg = cp.black, fg = cp.yellow },
      BufferInactiveSign { bg = cp.black, fg = cp.blue },
      BufferInactiveTarget { bg = cp.black, fg = cp.red },
      BufferTabpages { bg = cp.grey, fg = 'NONE' },
      BufferTabpageFill { bg = cp.blacker },
      BufferOffset { bg = cp.blacker, fg = cp.accent },
    }
  end
)

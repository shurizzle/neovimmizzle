local lush = require('lush')
local cp = require('config.colors.bluesky.palette')

---@diagnostic disable: undefined-global
return lush(function()
  return {
    NvimTreeRootFolder { fg = cp.almostwhite },
    NvimTreeNormal { bg = cp.blacker },
    NvimTreeNormalNC { bg = cp.blacker },
    NvimTreeVertSplit { bg = cp.blacker },
    NvimTreeFolderIcon { fg = cp.blue },
    NvimTreeIndentMarker { fg = cp.grey },
    NvimTreeStatusLine { bg = cp.blacker },
    NvimTreeStatusLineNC { fg = cp.blacker, bg = cp.blacker },
    NvimTreeEndOfBuffer { fg = cp.blacker, bg = cp.blacker },
    NvimTreeSignColumn { fg = cp.blacker, bg = cp.blacker },
  }
end)

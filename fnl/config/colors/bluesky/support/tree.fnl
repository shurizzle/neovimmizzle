(let [lush (require :lush)
      cp (require :config.colors.bluesky.palette)]
  (lush (fn []
          [(NvimTreeRootFolder {:fg cp.almostwhite})
           (NvimTreeNormal {:bg cp.blacker})
           (NvimTreeNormalNC {:bg cp.blacker})
           (NvimTreeVertSplit {:bg cp.blacker})
           (NvimTreeFolderIcon {:fg cp.blue})
           (NvimTreeIndentMarker {:fg cp.grey})
           (NvimTreeStatusLine {:bg cp.blacker})
           (NvimTreeStatusLineNC {:fg cp.blacker :bg cp.blacker})
           (NvimTreeEndOfBuffer {:fg cp.blacker :bg cp.blacker})
           (NvimTreeSignColumn {:fg cp.blacker :bg cp.blacker})])))

(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (NvimTreeRootFolder :fg cp.almostwhite)
    (NvimTreeNormal :bg cp.bg+)
    (NvimTreeNormalNC :bg cp.bg+)
    (NvimTreeVertSplit :bg cp.bg+)
    (NvimTreeFolderIcon :fg cp.blue)
    (NvimTreeIndentMarker :fg cp.grey)
    (NvimTreeStatusLine :bg cp.bg+)
    (NvimTreeStatusLineNC :fg cp.bg+ :bg cp.bg+)
    (NvimTreeEndOfBuffer :fg cp.bg+ :bg cp.bg+)
    (NvimTreeSignColumn :fg cp.bg+ :bg cp.bg+)))


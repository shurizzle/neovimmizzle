(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (BufferCurrent :bg cp.grey :fg cp.fg)
    (BufferCurrentIndex BufferCurrent)
    (BufferCurrentMod :bg cp.grey :fg cp.yellow)
    (BufferCurrentSign :bg cp.grey :fg cp.blue)
    (BufferCurrentTarget :bg cp.grey :fg cp.red)
    (BufferVisible :bg cp.almostbg :fg cp.fg)
    (BufferVisibleIndex BufferVisible)
    (BufferVisibleMod :bg cp.almostbg :fg cp.yellow)
    (BufferVisibleSign :bg cp.almostbg :fg cp.blue)
    (BufferVisibleTarget :bg cp.almostbg :fg cp.red)
    (BufferInactive :bg cp.bg :fg cp.grey)
    (BufferInactiveIndex BufferInactive)
    (BufferInactiveMod :bg cp.bg :fg cp.yellow)
    (BufferInactiveSign :bg cp.bg :fg cp.blue)
    (BufferInactiveTarget :bg cp.bg :fg cp.red)
    (BufferTabpages :bg cp.grey)
    (BufferTabpageFill :bg cp.bg+)
    (BufferOffset :bg cp.bg+ :fg cp.accent)))


(import-macros {: blush} :config.colors.blush.macros)
(local cp (require :config.colors.bluesky.palette))

;; fnlfmt: skip
(fn [cp]
  (blush
    (IblIndent :fg cp.almostblack)
    (IblScope :fg cp.white)))


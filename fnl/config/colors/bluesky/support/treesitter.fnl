(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (TSWarning :fg cp.bg :bg cp.yellow)
    (TSDanger :fg cp.bg :bg cp.red)
    ("@embedded" :fg cp.fg)))

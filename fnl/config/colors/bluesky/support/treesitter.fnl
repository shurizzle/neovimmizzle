(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (TSWarning :fg cp.black :bg cp.yellow)
    (TSDanger :fg cp.black :bg cp.red)
    ("@embedded" :fg cp.white)))


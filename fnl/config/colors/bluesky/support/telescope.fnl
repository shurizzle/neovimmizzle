(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (TelescopeBorder :fg cp.blue)
    (TelescopeMatching +italic +underline)))


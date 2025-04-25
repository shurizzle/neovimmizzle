(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (prologClause :fg cp.fg)))

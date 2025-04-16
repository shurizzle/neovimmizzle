(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp]
  (blush
    (IlluminatedWordText +underline)
    (illuminateWordRead IlluminatedWordText)
    (illuminateWordWrite IlluminatedWordText)
    (illuminatedWord CursorLine)))


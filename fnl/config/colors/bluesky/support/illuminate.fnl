(import-macros {: blush} :config.colors.blush.macros)
(local cp (require :config.colors.bluesky.palette))

(blush
  (IlluminatedWordText +underline)
  (illuminateWordRead IlluminatedWordText)
  (illuminateWordWrite IlluminatedWordText))

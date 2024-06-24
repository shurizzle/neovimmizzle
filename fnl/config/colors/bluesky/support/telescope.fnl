(import-macros {: blush} :config.colors.blush.macros)
(local cp (require :config.colors.bluesky.palette))

;; fnlfmt: skip
(blush
  (TelescopeBorder :fg cp.blue)
  (TelescopeMatching +italic +underline))


(import-macros {: blush} :config.colors.blush.macros)
(local cp (require :config.colors.bluesky.palette))

(blush (TelescopeBorder :fg cp.blue) (TelescopeMatching +italic +underline))

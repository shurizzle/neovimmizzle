(import-macros {: blush} :config.colors.blush.macros)
(local cp (require :config.colors.bluesky.palette))

(blush (TSWarning :fg cp.black :bg cp.yellow)
       (TSDanger :fg cp.black :bg cp.red) ("@embedded" :fg cp.white))

(import-macros {: blush} :config.colors.blush.macros)
(local cp (require :config.colors.bluesky.palette))

;; fnlfmt: skip
(fn [cp]
  (blush
    (GitSignsAdd :fg cp.green)
    (GitSignsChange :fg cp.yellow)
    (GitSignsDelete :fg cp.red)
    (GitSignsAddNr :fg cp.green)
    (GitSignsChangeNr :fg cp.yellow)
    (GitSignsDeleteNr :fg cp.red)
    (GitSignsAddLn :fg cp.green)
    (GitSignsChangeLn :fg cp.yellow)
    (GitSignsDeleteLn :fg cp.red)))

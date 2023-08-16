(let [lush (require :lush)
      cp (require :config.colors.bluesky.palette)]
  (lush (fn []
          [(TelescopeBorder {:fg cp.blue})
           (TelescopeMatching {:gui "italic,underline"})])))

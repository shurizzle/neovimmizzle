(let [lush (require :lush)
      cp (require :config.colors.bluesky.palette)]
  (lush (fn []
          [(prologClause {:fg cp.white})])))

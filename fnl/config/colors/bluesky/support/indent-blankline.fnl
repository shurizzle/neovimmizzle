(let [lush (require :lush)
      cp (require :config.colors.bluesky.palette)]
  (lush (fn []
          [(IndentBlanklineChar {:fg cp.almostblack })
           (IndentBlanklineContextChar {:fg cp.white })])))

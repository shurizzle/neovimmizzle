(let [lush (require :lush)
      cp (require :config.colors.bluesky.palette)]
  (lush (fn []
          [(IblIndent {:fg cp.almostblack})
           (IblScope {:fg cp.white})])))

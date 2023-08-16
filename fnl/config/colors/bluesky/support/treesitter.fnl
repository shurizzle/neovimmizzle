(let [lush (require :lush)
      cp (require :config.colors.bluesky.palette)]
  (lush (fn [{: sym}]
          [(TSWarning {:fg cp.black :bg cp.yellow})
           (TSDanger {:fg cp.black :bg cp.red})
           ((sym "@embedded") {:fg cp.white})])))

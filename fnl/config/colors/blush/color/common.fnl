(fn round [val]
  (math.floor (+ val 0.5)))

(fn rgb->hex [rgb]
  (string.format "#%02X%02X%02X" rgb.r rgb.g rgb.b))

(fn rgb [r g b]
  (setmetatable {: r : g : b} {:__tostring rgb->hex}))

{: round
 : rgb->hex
 : rgb}

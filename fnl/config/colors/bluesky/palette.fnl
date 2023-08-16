(local {: hsl} (require :lush))

(let [black (hsl 0 0 16)
      white (hsl 0 0 93)
      blue (hsl 212 100 59)
      yellow (hsl 53 100 50)
      red (hsl 350 72 46)
      green (hsl 146 75 35)
      grey (black.lighten 20)]
  {: black
   : white
   : blue
   : yellow
   : red
   : green
   :blacker (black.darken 10)
   :almostblack (black.lighten 3)
   : grey
   :secondary (grey.lighten 20)
   :accent ((. (blue.lighten 20) :saturate) 50)
   :almostwhite (blue.lighten 40)})

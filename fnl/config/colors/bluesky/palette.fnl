(local {: hex->hsl :hsl {: saturate : lighten : darken}}
       (require :config.colors.blush))

(let [black "#282828"
      black-hsl (hex->hsl black)
      blue "#2F90FE"
      blue-hsl (hex->hsl blue)
      white "#EEEEEE"
      yellow "#FFE300"
      red "#C8213D"
      green "#169C51"
      grey (lighten black-hsl 20)]
  {: white
   : yellow
   : red
   : green
   : black
   : blue
   : grey
   :secondary (lighten grey 20)
   :blacker (darken black-hsl 10)
   :almostblack (lighten black-hsl 3)
   :accent (-> blue-hsl (lighten 20) (saturate 50))
   :almostwhite (lighten blue-hsl 40)})

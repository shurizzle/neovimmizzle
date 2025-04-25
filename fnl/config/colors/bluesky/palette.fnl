(local {: hex->hsl :hsl {: saturate : lighten : darken}}
       (require :config.colors.blush))

(let [black "#282828"
      black-hsl (hex->hsl black)
      blue "#2F90FE"
      blue-hsl (hex->hsl blue)
      white "#EEEEEE"
      white-hsl (hex->hsl white)
      yellow "#FFE300"
      red "#C8213D"
      green "#169C51"
      grey (lighten black-hsl 20)
      dark {: white
            : yellow
            : red
            : green
            : black
            : blue
            : grey
            :fg white
            :bg black
            :secondary (lighten grey 20)
            :bg+ (darken black-hsl 10)
            :almostbg (lighten black-hsl 3)
            :accent (-> blue-hsl (lighten 20) (saturate 50))
            :almostwhite (lighten blue-hsl 40)}
      light (collect [k v (pairs dark)] (values k (tostring v)))]
  (set light.fg black)
  (set light.bg white)
  (set light.bg+ (darken white-hsl 10))
  (set light.almostbg (darken white-hsl 3))
  {: dark : light})

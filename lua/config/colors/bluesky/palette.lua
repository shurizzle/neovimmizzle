local lush = require('lush')
local hsl = lush.hsl

local black = hsl(0, 0, 16)
local white = hsl(0, 0, 93)
local blue = hsl(212, 100, 59)
local yellow = hsl(53, 100, 50)
local red = hsl(350, 72, 46)
local green = hsl(146, 75, 35)

local grey = black.lighten(20)

return {
  black = black,
  white = white,
  blue = blue,
  yellow = yellow,
  red = red,
  green = green,
  blacker = black.darken(10),
  almostblack = black.lighten(3),
  grey = grey,
  secondary = grey.lighten(20),
  accent = blue.lighten(20).saturate(50),
  almostwhite = blue.lighten(40),
}

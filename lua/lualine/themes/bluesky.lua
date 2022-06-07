local cp = require('config.colors.palette')

return {
  normal = {
    a = { fg = cp.black, bg = cp.white, gui = 'bold' },
    b = { fg = cp.white, bg = cp.grey },
    c = { fg = cp.white, bg = cp.blacker },
  },
  insert = {
    a = { fg = cp.white, bg = cp.green, gui = 'bold' },
  },
  visual = {
    a = { fg = cp.black, bg = cp.almostwhite, gui = 'bold' },
  },
  replace = {
    a = { fg = cp.white, bg = cp.red, gui = 'bold' },
  },
  inactive = {
    a = { fg = cp.almostwhite, bg = cp.grey, gui = 'bold' },
    b = { fg = cp.grey, bg = cp.blacker },
    c = { fg = cp.grey, bg = cp.blacker },
  },
}

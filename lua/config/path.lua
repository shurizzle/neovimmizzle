local platform = require('config.platform')

local dir_sep = platform.is.win and '\\' or '/'

local path = {
  dir_sep = dir_sep,
  sep = platform.is.win and ';' or ':',
  join = function(...) return table.concat({ ... }, dir_sep) end,
  real = function(path) return vim.loop.fs_realpath(path) end,
  dirname = function(path) return vim.fn.fnamemodify(path, ':h') end,
  canonical = function(path) return vim.fn.fnamemodify(path, ':p') end,
  file = function(path) return vim.fn.fnamemodify(path, ':h') end,
  extension = function(path) return vim.fn.fnamemodify(path, ':e') end,
}

path.init_dir = path.real(
  path.join(
    path.dirname(({ debug.getinfo(1, 'S').source:gsub('^@', '') })[1]),
    '..',
    '..'
  )
)

return setmetatable({}, {
  __index = function(_, key) return path[key] end,
})

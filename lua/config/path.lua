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

function path.dirs()
  return vim.tbl_map(
    function(x) return x:gsub(vim.pesc(path.dir_sep) .. '+$', '') end,
    vim.split(vim.env.PATH, vim.pesc(path.sep), { trimempty = true })
  )
end

local function set_path(paths) vim.env.PATH = table.concat(paths, path.sep) end

function path.prepend(dir)
  local dirs = vim.tbl_filter(function(e) return e ~= dir end, path.dirs())
  table.insert(dirs, 1, dir)
  set_path(dirs)
end

function path.append(dir)
  local dirs = vim.tbl_filter(function(e) return e ~= dir end, path.dirs())
  table.insert(dirs, dir)
  set_path(dirs)
end

function path.which(bin)
  for _, dir in ipairs(path.dirs()) do
    local p = path.join(dir, bin)
    if executable(p) then return p end
  end
end

return setmetatable({}, {
  __index = function(_, key) return path[key] end,
})

local path_sep
if (vim.loop.os_uname().sysname):match("Windows") then
  path_sep = "\\"
else
  path_sep = "/"
end
local function path_join(base, ...)
  _G.assert((nil ~= base), "Missing argument base on /home/shura/.config/nvim/init.fnl:3")
  return table.concat({base, ...}, path_sep)
end
local function dirname(path)
  _G.assert((nil ~= path), "Missing argument path on /home/shura/.config/nvim/init.fnl:6")
  return vim.fn.fnamemodify(path, ":h")
end
local init_dir
local function _2_(s)
  return {s:gsub("^@", "")}
end
init_dir = vim.loop.fs_realpath(dirname((_2_((debug.getinfo(1, "S")).source))[1]))
if not vim.tbl_contains((vim.opt.rtp):get(), init_dir) then
  do end (vim.opt.rtp):append(init_dir)
else
end
local function git_clone(url, dir, _3fparams, _3fcallback)
  _G.assert((nil ~= dir), "Missing argument dir on /home/shura/.config/nvim/init.fnl:19")
  _G.assert((nil ~= url), "Missing argument url on /home/shura/.config/nvim/init.fnl:19")
  local install_path = path_join(vim.fn.stdpath("data"), "lazy", dir)
  if not vim.loop.fs_stat(install_path) then
    do
      local cmd = {"git", "clone"}
      if (nil ~= _3fparams) then
        for _, value in ipairs(_3fparams) do
          table.insert(cmd, value)
        end
      else
      end
      table.insert(cmd, url)
      table.insert(cmd, install_path)
      vim.fn.system(cmd)
    end
    if (vim.v.shell_error == 0) then
      do end (vim.opt.rtp):append(install_path)
    else
    end
    if ("function" == type(_3fcallback)) then
      return _3fcallback(vim.v.shell_error, install_path)
    else
      return nil
    end
  else
    do end (vim.opt.rtp):append(install_path)
    if ("function" == type(_3fcallback)) then
      return _3fcallback(0, install_path)
    else
      return nil
    end
  end
end
if (vim.fn.has("nvim-0.9.0") == 0) then
  git_clone("https://github.com/lewis6991/impatient.nvim", "impatient.nvim", {"--depth", "1"})
  local function _9_()
    return require("impatient")
  end
  local function _10_()
    return vim.api.nvim_echo({{"Error while loading impatient", "ErrorMsg"}}, true, {})
  end
  xpcall(_9_, _10_)
else
  vim.loader.enable()
end
git_clone("https://github.com/folke/lazy.nvim.git", "lazy.nvim", {"--filter=blob:none", "--branch=stable"})
git_clone("https://github.com/rktjmp/hotpot.nvim.git", "hotpot.nvim", {"--filter=blob:none", "--single-branch"})
local hotpot = require("hotpot")
do
  local setup = hotpot.setup
  setup({provide_require_fennel = true, enable_hotpot_diagnostics = true, compiler = {modules = {correlate = true}, macros = {env = "_COMPILER", compilerEnv = _G}}})
end
require("hotpot.fennel")
do
  local fns
  local function _12_(what)
    return print(vim.inspect(what))
  end
  local function _13_(what)
    return (vim.fn.has(what) ~= 0)
  end
  local function _14_(what)
    return (vim.fn.executable(what) ~= 0)
  end
  local function _15_(t)
    _G.assert((nil ~= t), "Missing argument t on /home/shura/.config/nvim/init.fnl:80")
    local function _16_(_241, _242)
      return t[_242]
    end
    return setmetatable({}, {__index = _16_})
  end
  fns = {inspect = _12_, has = _13_, executable = _14_, ["readonly-table"] = _15_}
  local _let_17_ = require("fennel.compiler")
  local global_mangling = _let_17_["global-mangling"]
  for name, f in pairs(fns) do
    _G[global_mangling(name)] = f
    _G[name] = f
  end
end
do
  local build = hotpot.api.make.build
  local uv = vim.loop
  local init_file = path_join(init_dir, "init.fnl")
  local build_init
  local function _18_()
    local _let_19_ = require("fennel.compiler")
    local global_unmangling = _let_19_["global-unmangling"]
    local allowed_globals
    local function _20_()
      local keys = {}
      for n, _ in pairs(_G) do
        keys[global_unmangling(n)] = true
        keys = keys
      end
      return keys
    end
    allowed_globals = vim.tbl_keys(_20_())
    local opts = {verbosity = 0, compiler = {modules = {allowedGlobals = allowed_globals}}}
    local function _21_(_241)
      return _241
    end
    return build(init_file, opts, ".+", _21_)
  end
  build_init = _18_
  local handle = uv.new_fs_event()
  local function _22_()
    return vim.schedule(build_init)
  end
  uv.fs_event_start(handle, init_file, {}, _22_)
  local function _23_()
    return uv.close(handle)
  end
  vim.api.nvim_create_autocmd("VimLeavePre", {callback = _23_})
end
require("config.ft")
require("config.utils")
do end (require("config.colors")).setup()
require("config.keymaps")
require("config.options")
do end (require("config.winbar")).setup()
require("config.plugins")
require("config.rust")
return (require("config.lang")).config()
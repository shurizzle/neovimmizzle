local path_sep
if (vim.loop.os_uname().sysname):match("Windows") then
  path_sep = "\\"
else
  path_sep = "/"
end
local function path_join(base, ...)
  _G.assert((nil ~= base), "Missing argument base on /Users/shura/.config/nvim/init.fnl:3")
  return table.concat({base, ...}, path_sep)
end
local function dirname(path)
  _G.assert((nil ~= path), "Missing argument path on /Users/shura/.config/nvim/init.fnl:6")
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
  _G.assert((nil ~= dir), "Missing argument dir on /Users/shura/.config/nvim/init.fnl:19")
  _G.assert((nil ~= url), "Missing argument url on /Users/shura/.config/nvim/init.fnl:19")
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
require("hotpot.fennel")
local function additional_macros()
  local f = require("hotpot.fennel")
  local fc = require("fennel.compiler")
  return f.eval("(fn test-notify [] `(vim.notify :test :info {:title :macro})) {: test-notify}", {env = "_COMPILER", scope = fc.scopes.compiler})
end
do
  local fc = require("fennel.compiler")
  fc.scopes.global.macros = vim.tbl_deep_extend("force", fc.scopes.global.macros, additional_macros())
end
hotpot.setup({provide_require_fennel = true, enable_hotpot_diagnostics = true, compiler = {modules = {correlate = true}, macros = {env = "_COMPILER", ["compiler-env"] = _G}}})
do
  local _let_12_ = require("fennel.compiler")
  local global_mangling = _let_12_["global-mangling"]
  for name, f in pairs(require("config.stdlib")) do
    _G[global_mangling(name)] = f
    _G[name] = f
  end
end
do
  local fns
  local function _13_(what)
    return print(vim.inspect(what))
  end
  local function _14_(what)
    return (vim.fn.has(what) ~= 0)
  end
  local function _15_(what)
    return (vim.fn.executable(what) ~= 0)
  end
  local function _16_(t)
    _G.assert((nil ~= t), "Missing argument t on /Users/shura/.config/nvim/init.fnl:90")
    local function _17_(_241, _242)
      return t[_242]
    end
    return setmetatable({}, {__index = _17_})
  end
  fns = {inspect = _13_, has = _14_, executable = _15_, ["readonly-table"] = _16_}
  local _let_18_ = require("fennel.compiler")
  local global_mangling = _let_18_["global-mangling"]
  for name, f in pairs(fns) do
    _G[global_mangling(name)] = f
    _G[name] = f
  end
end
do
  local build = hotpot.api.make.build
  local uv = vim.loop
  local init_file = path_join(init_dir, "init.fnl")
  local fnl_lualine_theme = path_join(init_dir, "fnl", "lualine", "themes", "bluesky.fnl")
  local lua_lualine_theme = path_join(init_dir, "lua", "lualine", "themes", "bluesky.fnl")
  local _let_19_ = require("fennel.compiler")
  local global_unmangling = _let_19_["global-unmangling"]
  local allowed_globals
  local function _20_(...)
    local tbl_14_auto = {}
    for n, _ in pairs(_G) do
      local k_15_auto, v_16_auto = global_unmangling(n), true
      if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
        tbl_14_auto[k_15_auto] = v_16_auto
      else
      end
    end
    return tbl_14_auto
  end
  allowed_globals = vim.tbl_keys(_20_(...))
  local compiler_opts = {verbosity = 0, compiler = {modules = {allowedGlobals = allowed_globals}}}
  local function watch(file, callback)
    local handle = uv.new_fs_event()
    local function _22_()
      return vim.schedule(callback)
    end
    uv.fs_event_start(handle, file, {}, _22_)
    local function _23_()
      return uv.close(handle)
    end
    return vim.api.nvim_create_autocmd("VimLeavePre", {callback = _23_})
  end
  local function build_init()
    local function _24_(_241)
      return _241
    end
    return build(init_file, compiler_opts, ".+", _24_)
  end
  local function build_lualine()
    local function _25_()
      return lua_lualine_theme
    end
    return build(fnl_lualine_theme, compiler_opts, ".+", _25_)
  end
  watch(init_file, build_init)
  watch(fnl_lualine_theme, build_lualine)
end
require("config.ft")
require("config.utils")
require("config.options")
do end (require("config.colors")).setup()
require("config.keymaps")
do end (require("config.winbar")).setup()
require("config.plugins")
require("config.rust")
return (require("config.lang")).config()
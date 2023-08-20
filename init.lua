do local _ = (function(...) local path_sep
if (vim.loop.os_uname().sysname):match("Windows") then
  path_sep = "\\"
else
  path_sep = "/"
end
local function path_join(base, ...)
  _G.assert((nil ~= base), "Missing argument base on /Users/shura/.config/nvim/fnl/config/bootstrap.fnl:3")
  return table.concat({base, ...}, path_sep)
end
local realpath = vim.loop.fs_realpath
local function dirname(path)
  _G.assert((nil ~= path), "Missing argument path on /Users/shura/.config/nvim/fnl/config/bootstrap.fnl:8")
  return vim.fn.fnamemodify(path, ":h")
end
local init_dir
local function _2_(s)
  return {s:gsub("^@", "")}
end
init_dir = realpath(dirname((_2_((debug.getinfo(1, "S")).source))[1]))
if not vim.tbl_contains((vim.opt.rtp):get(), init_dir) then
  do end (vim.opt.rtp):append(init_dir)
else
end
local function git_clone(url, dir, _3fparams, _3fcallback)
  _G.assert((nil ~= dir), "Missing argument dir on /Users/shura/.config/nvim/fnl/config/bootstrap.fnl:21")
  _G.assert((nil ~= url), "Missing argument url on /Users/shura/.config/nvim/fnl/config/bootstrap.fnl:21")
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
local function slurp(path)
  local _12_, _13_ = io.open(path, "r")
  if ((_12_ == nil) and true) then
    local _msg = _13_
    return nil
  elseif (nil ~= _12_) then
    local f = _12_
    local content = f:read("*all")
    f:close()
    return content
  else
    return nil
  end
end
local function additional_macros()
  local f = require("hotpot.fennel")
  local fc = require("fennel.compiler")
  return f.eval(slurp(path_join(init_dir, "fnl", "config", "init-macros.fnl")), {env = "_COMPILER", scope = fc.scopes.compiler})
end
do
  local fc = require("fennel.compiler")
  fc.scopes.global.macros = vim.tbl_deep_extend("force", fc.scopes.global.macros, additional_macros())
end
local function preprocessor(src, _15_)
  local _arg_16_ = _15_
  local path = _arg_16_["path"]
  local macro_3f = _arg_16_["macro?"]
  local prefix = path_join(init_dir, "fnl", "config", "lang", "_", "")
  if (not macro_3f and vim.startswith(realpath(path), prefix)) then
    return ("(import-macros {: mkconfig} :config.lang.macros)\n" .. src)
  else
    return src
  end
end
hotpot.setup({provide_require_fennel = true, enable_hotpot_diagnostics = true, compiler = {modules = {correlate = true}, macros = {env = "_COMPILER", ["compiler-env"] = _G}, preprocessor = preprocessor}})
do
  local fc = require("fennel.compiler")
  do end (fc.scopes.global.includes)["config.bootstrap"] = "(function(...) end)"
end
local function watcher()
  local _let_18_ = hotpot.api.make
  local build = _let_18_["build"]
  local _let_19_ = hotpot.api.compile
  local compile_file = _let_19_["compile-file"]
  local _let_20_ = require("hotpot.searcher")
  local search = _let_20_["search"]
  local uv = vim.loop
  local init_file = path_join(init_dir, "init.fnl")
  local fnl_lualine_theme = path_join(init_dir, "fnl", "lualine", "themes", "bluesky.fnl")
  local lua_lualine_theme = path_join(init_dir, "lua", "lualine", "themes", "bluesky.fnl")
  local bootstrap_file
  do
    local _21_ = search({prefix = "fnl", extension = "fnl", modnames = {"config.bootstrap.init", "config.bootstrap"}})
    if ((_G.type(_21_) == "table") and (nil ~= (_21_)[1])) then
      local path = (_21_)[1]
      bootstrap_file = path
    elseif (_21_ == nil) then
      bootstrap_file = error("Cannot find config.bootstrap")
    else
      bootstrap_file = nil
    end
  end
  local _let_23_ = require("fennel.compiler")
  local global_unmangling = _let_23_["global-unmangling"]
  local allowed_globals
  local function _24_()
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
  allowed_globals = vim.tbl_keys(_24_())
  local compiler_opts = {verbosity = 0, ["force?"] = true, compiler = {modules = {allowedGlobals = allowed_globals, env = "_COMPILER"}}}
  local function watch(file, callback)
    local handle = uv.new_fs_event()
    local function _26_()
      return vim.schedule(callback)
    end
    uv.fs_event_start(handle, file, {}, _26_)
    local function _27_()
      return uv.close(handle)
    end
    return vim.api.nvim_create_autocmd("VimLeavePre", {callback = _27_})
  end
  local function compile_bootstrap()
    local _28_, _29_ = compile_file(bootstrap_file, compiler_opts)
    if ((_28_ == true) and (nil ~= _29_)) then
      local code = _29_
      local fc = require("fennel.compiler")
      do end (fc.scopes.global.includes)["config.bootstrap"] = ("(function(...) " .. code .. " end)()")
      return nil
    elseif ((_28_ == false) and (nil ~= _29_)) then
      local err = _29_
      return error(err)
    else
      return nil
    end
  end
  compile_bootstrap()
  local function build_init()
    local function _31_(_241)
      return _241
    end
    return build(init_file, compiler_opts, ".+", _31_)
  end
  local function build_init_bootstrap()
    compile_bootstrap()
    local function _32_(_241)
      return _241
    end
    return build(init_file, compiler_opts, ".+", _32_)
  end
  local function build_lualine()
    local function _33_()
      return lua_lualine_theme
    end
    return build(fnl_lualine_theme, compiler_opts, ".+", _33_)
  end
  watch(bootstrap_file, build_init_bootstrap)
  watch(init_file, build_init)
  return watch(fnl_lualine_theme, build_lualine)
end
return vim.schedule(watcher) end)() end
do
  local _let_1_ = require("fennel.compiler")
  local global_mangling = _let_1_["global-mangling"]
  for name, f in pairs(require("config.stdlib")) do
    _G[global_mangling(name)] = f
    _G[name] = f
  end
end
do
  local fns
  local function _2_(what)
    return print(vim.inspect(what))
  end
  local function _3_(what)
    return (vim.fn.has(what) ~= 0)
  end
  local function _4_(what)
    return (vim.fn.executable(what) ~= 0)
  end
  local function _5_(t)
    _G.assert((nil ~= t), "Missing argument t on /Users/shura/.config/nvim/init.fnl:11")
    local function _6_(_241, _242)
      return t[_242]
    end
    local function _7_()
      return nil
    end
    return setmetatable({}, {__index = _6_, __newindex = _7_})
  end
  fns = {inspect = _2_, has = _3_, executable = _4_, ["readonly-table"] = _5_}
  local _let_8_ = require("fennel.compiler")
  local global_mangling = _let_8_["global-mangling"]
  for name, f in pairs(fns) do
    _G[global_mangling(name)] = f
    _G[name] = f
  end
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
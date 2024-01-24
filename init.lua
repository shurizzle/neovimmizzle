 package.preload["config.bootstrap"] = package.preload["config.bootstrap"] or function(...) local uv = require("luv") local windows_3f = (uv.os_uname().version):match("Windows") local path_sep if windows_3f then path_sep = "\\" else path_sep = "/" end local function join_paths(...) return table.concat({...}, path_sep) end local function helptags(path) local docpath = join_paths(path, "doc") if uv.fs_stat(docpath) then return vim.cmd.helptags(docpath) else return nil end end vim.fn.mkdir(join_paths(vim.fn.stdpath("data"), "lazy"), "p") local function git_clone(url, dir, _3fparams, _3fcallback) vim.validate({url = {url, "s"}, dir = {dir, "s"}, ["?params"] = {_3fparams, "t", true}, ["?callback"] = {_3fcallback, "f", true}}) local install_path = join_paths(vim.fn.stdpath("data"), "lazy", dir) if not uv.fs_stat(install_path) then do local cmd = {"git", "clone", "--filter=blob:none"} if (nil ~= _3fparams) then for _, value in ipairs(_3fparams) do table.insert(cmd, value) end else end table.insert(cmd, url) table.insert(cmd, install_path) vim.fn.system(cmd) end if (vim.v.shell_error == 0) then helptags(install_path) do end (vim.opt.rtp):append(install_path) else end if ("function" == type(_3fcallback)) then return _3fcallback(vim.v.shell_error, install_path) else return nil end else do end (vim.opt.rtp):append(install_path) if ("function" == type(_3fcallback)) then return _3fcallback(0, install_path) else return nil end end end if (vim.fn.has("nvim-0.9.0") == 0) then git_clone("https://github.com/lewis6991/impatient.nvim", "impatient.nvim") local function _8_() return require("impatient") end local function _9_() return vim.api.nvim_echo({{"Error while loading impatient", "ErrorMsg"}}, true, {}) end xpcall(_8_, _9_) else vim.loader.enable() end git_clone("https://github.com/rktjmp/hotpot.nvim.git", "hotpot.nvim", {"--single-branch"}) git_clone("https://github.com/folke/lazy.nvim.git", "lazy.nvim", {"--branch=stable"}) local function has_bit_operators() local function version_has_bit_operators(_11_) local _arg_12_ = _11_ local major = _arg_12_[1] local minor = _arg_12_[2] if (major > 5) then return true elseif (major < 5) then return false elseif (minor > 2) then return true else return false end end if ("table" == type(_G.jit)) then return false else local _14_ if _G._VERSION then local tbl_18_auto = {} local i_19_auto = 0 for _, n in ipairs({(_G._VERSION):match("Lua (%d+)%.(%d+)")}) do local val_20_auto = tonumber(n) if (nil ~= val_20_auto) then i_19_auto = (i_19_auto + 1) do end (tbl_18_auto)[i_19_auto] = val_20_auto else end end _14_ = tbl_18_auto else _14_ = nil end if (nil ~= _14_) then return version_has_bit_operators(_14_) else return _14_ end end end local useBitLib = not has_bit_operators() require("hotpot").setup({provide_require_fennel = true, enable_hotpot_diagnostics = true, compiler = {modules = {correlate = true, useBitLib = useBitLib}, macros = {env = "_COMPILER", compilerEnv = _G, useBitLib = useBitLib, allowedGlobals = false}, preprocessor = nil}}) do local fennel = require("hotpot.fennel") local base = join_paths(vim.fn.stdpath("config"), "fnl") fennel.path = table.concat({join_paths(base, "?.fnl"), join_paths(base, "?", "init.fnl"), fennel.path}, ";") end local function slurp(path) local _19_, _20_ = io.open(path, "r") if ((_19_ == nil) and true) then local _msg = _20_ return nil elseif (nil ~= _19_) then local f = _19_ local content = f:read("*all") f:close() return content else return nil end end local function additional_macros() local f = require("hotpot.fennel") local fc = require("fennel.compiler") return f.eval(slurp(join_paths(vim.fn.stdpath("config"), "fnl", "config", "init-macros.fnl")), {env = "_COMPILER", scope = fc.scopes.compiler}) end do local fc = require("fennel.compiler") fc.scopes.global.macros = vim.tbl_deep_extend("force", fc.scopes.global.macros, additional_macros()) end local function build(files) local _local_22_ = require("hotpot.api.make") local build0 = _local_22_["build"] local _local_23_ = require("fennel.compiler") local global_unmangling = _local_23_["global-unmangling"] local allowedGlobals local function _24_() local tbl_14_auto = {} for n, _ in pairs(_G) do local k_15_auto, v_16_auto = global_unmangling(n), true if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then tbl_14_auto[k_15_auto] = v_16_auto else end end return tbl_14_auto end allowedGlobals = vim.tbl_keys(_24_()) return build0(vim.fn.stdpath("config"), {verbose = true, atomic = true, force = true, compiler = {modules = {allowedGlobals = allowedGlobals, correlate = true, useBitLib = useBitLib}}}, files) end local function hook_init_rebuild(file) local function rebuild_on_save(_26_) local _arg_27_ = _26_ local buf = _arg_27_["buf"] local function _28_() return build({{"init.fnl", true}}) end return vim.api.nvim_create_autocmd("BufWritePost", {buffer = buf, callback = _28_}) end return vim.api.nvim_create_autocmd("BufRead", {pattern = vim.fs.normalize(join_paths(vim.fn.stdpath("config"), file)), callback = rebuild_on_save}) end hook_init_rebuild("init.fnl") hook_init_rebuild(join_paths("fnl", "config", "bootstrap.fnl")) local path = join_paths("fnl", "lualine", "themes", "bluesky.fnl") local function rebuild_on_save(_29_) local _arg_30_ = _29_ local buf = _arg_30_["buf"] local function _31_() return build({{path, true}}) end return vim.api.nvim_create_autocmd("BufWritePost", {buffer = buf, callback = _31_}) end return vim.api.nvim_create_autocmd("BufRead", {pattern = vim.fs.normalize(join_paths(vim.fn.stdpath("config"), path)), callback = rebuild_on_save}) end require("config.bootstrap")

 do local fns local function _32_(what) return print(vim.inspect(what)) end
 local function _33_(what) return (vim.fn.has(what) ~= 0) end
 local function _34_(what) return (vim.fn.executable(what) ~= 0) end
 local function _35_(t) local function _36_(_241, _242) return t[_242] end
 local function _37_() return nil end return setmetatable({}, {__index = _36_, __newindex = _37_}) end fns = {inspect = _32_, has = _33_, executable = _34_, ["readonly-table"] = _35_}
 local _let_38_ = require("fennel.compiler") local global_mangling = _let_38_["global-mangling"]
 for name, f in pairs(require("config.stdlib")) do
 _G[global_mangling(name)] = f
 _G[name] = f end
 for name, f in pairs(fns) do
 _G[global_mangling(name)] = f
 _G[name] = f end end

 require("config.ft")
 require("config.utils")
 require("config.options")
 require("config.colors").setup()
 require("config.keymaps")
 require("config.winbar").setup()


 local function _39_() return require("config.lang").config() end vim.api.nvim_create_autocmd("User", {pattern = "LazyDone", callback = _39_})
 return require("config.plugins")
local os = (function(os)
  if os:match('Windows') then
    return 'windows'
  elseif os:match('Linux') then
    return 'linux'
  elseif os:match('Darwin') then
    return 'macos'
  elseif os:match('FreeBSD') then
    return 'freebsd'
  elseif os:match('DragonFly') then
    return 'dragonflybsd'
  elseif os:match('NetBSD') then
    return 'netbsd'
  else
    return 'unknown'
  end
end)(vim.loop.os_uname().sysname)

local ssh_remote = (function()
  local function extract(env)
    if env then
      local i = env:find('%s')

      if i then
        local remote = require('ip').parse(env:sub(0, i - 1))
        if remote then return remote end
      end
    end
  end

  local function coalesce_map(map, ...)
    for _, name in ipairs({ ... }) do
      local res = map(name)
      if res then return res end
    end
  end

  local res = coalesce_map(
    function(name) return extract(vim.env[name]) end,
    'SSH_CLIENT',
    'SSH_CONNECTION'
  )

  return res
end)()

local is = {}

local _is = {
  win = os == 'windows',
  lin = os == 'linux',
  mac = os == 'macos',
  fbsd = os == 'freebsd',
  dfbsd = os == 'dragonflybsd',
  nbsd = os == 'netbsd',
  ssh = ssh_remote ~= nil,
  headless = vim.tbl_isempty(vim.api.nvim_list_uis()),
}
_is.windows = _is.win
_is.linux = _is.lin
_is.macos = _is.mac
_is.freebsd = _is.fbsd
_is.dragonflybsd = _is.dfbsd
_is.netbsd = _is.nbsd
_is.bsd = _is.mac or _is.fbsd or _is.dfbsd or _is.nbsd

setmetatable(is, { __index = function(_, key) return _is[key] end })

local plat = {
  is = is,
  ssh = ssh_remote,
}

plat.ssh_remote = plat.ssh

return setmetatable({}, { __index = function(_, key) return plat[key] end })

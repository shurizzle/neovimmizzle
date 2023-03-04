local os = (function(os)
  if os:match('Windows') then
    return 'windows'
  elseif os:match('Linux') then
    return 'linux'
  elseif os:match('Darwin') then
    return 'macos'
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
  ssh = ssh_remote ~= nil,
  headless = vim.tbl_isempty(vim.api.nvim_list_uis()),
}
_is.windows = _is.win
_is.linux = _is.lin
_is.macos = _is.mac

setmetatable(is, { __index = function(_, key) return _is[key] end })

local plat = {
  is = is,
  ssh = ssh_remote,
}

plat.ssh_remote = plat.ssh

return setmetatable({}, { __index = function(_, key) return plat[key] end })
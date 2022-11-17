local _M = {}

_M.opt = true

_M.module_pattern = {
  '^luapad$',
  '^luapad%.',
}

local cmds = { 'Luapad', 'LuaRun', 'Lua' }

function _M.setup()
  local commands = vim.api.nvim_get_commands({})
  for _, cmd in ipairs(cmds) do
    if not commands[cmd] then
      vim.api.nvim_create_user_command(cmd, function(opts)
        require('packer.load')({ 'nvim-luapad' }, {
          cmd = cmd,
          l1 = opts.line1,
          l2 = opts.line2,
          bang = opts.bang and '!' or '',
          args = opts.args,
          ---@diagnostic disable-next-line
        }, _G.packer_plugins)
      end, {
        nargs = '*',
        range = true,
        bang = true,
        complete = 'file',
      })
    end
  end
end

function _M.config()
  require('luapad').setup({})
end

return _M

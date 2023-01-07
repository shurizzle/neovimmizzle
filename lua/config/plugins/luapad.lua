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
  local path = require('config.path')

  require('luapad').setup({
    on_init = function()
      local file = vim.api.nvim_buf_get_name(0)
      if not file then return end
      file = vim.loop.fs_realpath(file)
      if not file then return end
      local dir = vim.fn.fnamemodify(file, ':h')

      vim.loop.fs_copyfile(
        path.join(require('config.path').init_dir, '.luarc.json'),
        path.join(dir, '.luarc.json'),
        {
          ficlone = true,
          ficlone_force = true,
        }
      )
    end,
  })
end

return _M

local _M = {}

_M.lazy = true

_M.cmd = { 'Luapad', 'LuaRun', 'Lua' }

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

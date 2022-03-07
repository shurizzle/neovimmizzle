local util = require('lspconfig.util')

local root_pattern = util.root_pattern(
  'compile_commands.json',
  'compile_flags.txt',
  '.git'
)

return {
  root_dir = function(fname)
    local filename = util.path.is_absolute(fname) and fname
      or util.path.join(vim.loop.cwd(), fname)

    local path = (util.root_pattern('meson.build'))(filename)
    if path then
      return join_paths(path, 'build')
    else
      return root_pattern(filename)
    end
  end,
}

local _M = {}

_M.keys = {
  { mode = 'n', 'ys' },
  { mode = 'n', 'yss' },
  { mode = 'n', 'yS' },
  { mode = 'n', 'ySS' },
  { mode = 'x', 'S' },
  { mode = 'x', 'gS' },
  { mode = 'n', 'ds' },
  { mode = 'n', 'cs' },
}

function _M.config()
  local opts = require('nvim-surround.config').default_opts
  opts.keymaps.insert = nil
  opts.keymaps.insert_line = nil
  opts.aliases = {}
  require('nvim-surround').setup()
end

return _M

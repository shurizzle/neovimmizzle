local _M = {}

_M.keys = {
  { 'n', 'ys' },
  { 'n', 'yss' },
  { 'n', 'yS' },
  { 'n', 'ySS' },
  { 'x', 'S' },
  { 'x', 'gS' },
  { 'n', 'ds' },
  { 'n', 'cs' },
}

function _M.config()
  local opts = require('nvim-surround.config').default_opts
  opts.keymaps.insert = nil
  opts.keymaps.insert_line = nil
  opts.aliases = {}
  require('nvim-surround').setup()
end

return _M

local lush = require('lush')

local theme = { require('config.colors.bluesky.base') }

for _, name in ipairs {
  'gitsigns',
  'indent-blankline',
  'tree',
  'barbar',
  'telescope',
  'lsp',
  'treesitter',
} do
  table.insert(theme, require('config.colors.bluesky.support.' .. name))
end

return lush.merge(theme)

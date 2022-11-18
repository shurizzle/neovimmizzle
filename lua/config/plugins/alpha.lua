local _M = {}

function _M.config()
  local d = require('alpha.themes.dashboard')

  local buttons = {
    type = 'group',
    val = {
      d.button('e', '  New file', '<cmd>ene <CR>'),
      d.button('SPC f f', '  Find file'),
      d.button('SPC f h', '  Help'),
      d.button('SPC f g', '  Find word'),
    },
    opts = {
      spacing = 1,
    },
  }

  local message = '🎉 Have fun with neovim'
  if packer_plugins ~= nil then
    message = '🎉 neovim loaded '
      .. vim.tbl_count(
        vim.tbl_filter(function(p) return p.loaded end, packer_plugins)
      )
      .. '/'
      .. vim.tbl_count(packer_plugins)
      .. ' plugins'
  end

  local footer = {
    type = 'text',
    val = message,
    opts = {
      position = 'center',
      hl = 'Number',
    },
  }

  require('alpha').setup({
    layout = {
      { type = 'padding', val = 2 },
      d.section.header,
      { type = 'padding', val = 2 },
      buttons,
      footer,
    },
    opts = {
      margin = 5,
    },
  })
end

return _M

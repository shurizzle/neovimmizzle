local _M = {}

_M.lazy = false

function _M.config()
  local d = require('alpha.themes.dashboard')

  local day = os.date('%d%m')

  local pic = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  }

  local fireworks = {
    [[                                   .''.          ]],
    [[       .''.      .        *''*    :_\/_:     .   ]],
    [[      :_\/_:   _\(/_  .:.*_\/_*   : /\ :  .'.:.'.]],
    [[  .''.: /\ :   ./)\   ':'* /\ * :  '..'.  -=:o:=-]],
    [[ :_\/_:'.:::.    ' *''*    * '.\'/.' _\(/_'.':'.']],
    [[ : /\ : :::::     *_\/_*     -= o =-  /)\    '  *]],
    [[  '..'  ':::'     * /\ *     .'/.\'.   '         ]],
    [[      *            *..*         :                ]],
  }

  local mistletoe = {
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⡿⠿⠿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠟⠉⠀⠀⠀⠀⠀⠙⣷⣄⣠⣤⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡏⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠁⠀⠀⠈⠻⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⠀⠀⠀⠀⠀⢹⣇⠀⠀⠀⣠⣴⣿⡀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠹⣷⡀⠀⠀⠀⠀⠀⠀⢀⣴⠆⠀⠀⠀⠀⠀⣸⣿⣤⣴⠿⠛⠉⠸⣷⣤⣶⠟⢿⣦⡀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠈⣿⠛⠿⠿⠿⠟⢿⣶⣤⣀⣀⣤⡶⠟⢧⣀⠀⠀⠀⣀⣴⣿⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢷⣶⣤⣤⣄⣀]],
    [[⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⠀⣠⣼⣿⣏⠉⠁⠀⠀⠈⢹⡿⠿⠿⣿⡉⠙⠛⠿⢿⣶⣦⣤⣄⣀⣀⣀⣀⣠⡴⠀⠀⣀⣽⡿⠿⠛]],
    [[⠀⠀⠀⠀⠀⠀⢀⣾⠇⠀⠀⠀⣠⣾⡿⠋⠀⠻⣷⣤⣀⣀⣤⣿⣦⣄⡀⢹⣧⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⢀⣴⡿⠛⠉⠀⠀⠀]],
    [[⠀⠀⠀⠀⣀⣴⠟⠁⠀⢀⣤⡾⠟⠁⠀⠀⠀⠀⠈⢿⣟⢻⣯⡀⠉⠛⠛⠿⣿⣀⣤⣴⣶⣶⣶⣤⣄⡀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀⠀⠀]],
    [[⠀⢶⡶⠟⠋⠁⠀⠀⣠⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣦⡹⣿⣦⠀⠀⢸⣿⢿⡏⠁⠀⠀⠈⠉⠻⣿⣦⣴⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠈⢿⡄⠀⠀⢀⣾⠟⠀⠀⠀⠀⠀⢀⣤⣶⣾⡟⠛⠛⠛⠃⠈⠻⣷⣄⠀⠀⠈⢿⣦⡀⠀⠀⠀⠀⠈⠻⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠘⣧⠀⢠⡿⠁⠀⠀⠀⠀⢀⣶⡿⠋⣴⣿⣀⡀⠀⠀⠀⠀⠀⠈⢿⣷⣄⠀⠀⠙⠿⣷⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⢰⡏⠀⠙⠀⠀⠀⠀⠀⢠⣿⠏⠀⠸⠟⠛⠛⠻⣷⣦⡀⠀⠀⠀⠀⠙⢿⣦⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⣠⣿⣀⣤⣴⣶⣶⢶⣦⣄⣾⡏⠀⠀⠀⠀⠀⠀⠀⠈⢻⣷⡀⠀⠀⠀⠀⠀⢻⣧⡀⠀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⣴⣿⠿⠛⠋⠉⠀⠀⠀⠈⠙⠿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠻⣧⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠿⠿⠛⠛⠛⠿⢷⣦⣄⡀⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  }

  if day == '2412' or day == '2512' then
    pic = mistletoe
  elseif day == '3112' or day == '0101' then
    pic = fireworks
  end

  local header = {
    type = 'text',
    val = pic,
    opts = {
      position = 'center',
      hl = 'Type',
    },
  }

  local buttons = {
    type = 'group',
    val = {
      d.button('e', '  New file', '<cmd>ene <CR>'),
      d.button('COMMA f f', '󰈞  Find file'),
      d.button('COMMA f h', '󰡯  Help'),
      d.button('COMMA f g', '󰈬  Find word'),
    },
    opts = {
      spacing = 1,
    },
  }

  local message = '🎉 Have fun with neovim'

  ---@diagnostic disable-next-line: undefined-field
  if _G.packer_plugins ~= nil then
    message = '🎉 neovim loaded '
      .. vim.tbl_count(
        ---@diagnostic disable-next-line: undefined-field
        vim.tbl_filter(function(p) return p.loaded end, _G.packer_plugins)
      )
      .. '/'
      .. vim.tbl_count(packer_plugins)
      .. ' plugins'
  end

  local ok, cfg = pcall(require, 'lazy.core.config')
  if ok then
    local total = 0
    local loaded = 0
    for _, p in pairs(cfg.plugins) do
      total = total + 1
      if p._.loaded then loaded = loaded + 1 end
    end
    message = '🎉 neovim loaded ' .. loaded .. '/' .. total .. ' plugins'
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
      header,
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

local M = {}

function M.config()
  local catppuccin, cp =
    require('catppuccin'), require('catppuccin.api.colors').get_colors()

  catppuccin.setup({
    integrations = {
      cmp = true,
      telescope = true,
      barbar = true,
      indent_blankline = { enabled = true, colored_indent_levels = false },
      treesitter = true,
      nvimtree = {
        enabled = true,
        show_root = true,
      },
      notify = true,
    },
  })
  catppuccin.remap({
    NvimTreeVertSplit = { fg = cp.black1, bg = cp.black1 },
    NvimTreeStatusline = { fg = cp.black1, bg = cp.black1 },
    NvimTreeStatuslineNC = { fg = cp.black1, bg = cp.black1 },
  })

  colorscheme('catppuccin')
end

return M

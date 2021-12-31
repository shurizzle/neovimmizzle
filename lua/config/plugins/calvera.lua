local M = {}

function M.pre()
  vim.g.calvera_italic_keywords = false
  vim.g.calvera_borders = true
  vim.g.calvera_contrast = true
  vim.g.calvera_hide_eob = true
end

function M.config()
  require('calvera').set()
  local calvera = require('calvera.colors')
  local util = require('calvera.util')
  local bg = vim.g.calvera_disable_background == true and calvera.none
    or calvera.sidebar
  local h = {}
  h.LspSignatureActiveParameter = { fg = calvera.yellow, bg = bg }
  h.NvimTreeStatusLine = { fg = bg, bg = bg }
  h.NvimTreeStatusLineNC = h.NvimTreeStatusLine
  h.NvimTreeEndOfBuffer = h.NvimTreeStatusLineNC
  h.NvimTreeVertSplit = h.NvimTreeEndOfBuffer
  h.BufferOffset = { fg = calvera.blue, bg = bg }
  for group, colors in pairs(h) do
    util.highlight(group, colors)
  end
end

return M

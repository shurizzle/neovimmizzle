local _M = {}

_M.lazy = true

_M.ft = 'markdown'

function _M.setup()
  vim.g.nvim_markdown_preview_theme = 'github'
  if (vim.g.started_by_firenvim or 0) ~= 0 then
    vim.g.instant_markdown_autostart = 0
  end
end

return _M

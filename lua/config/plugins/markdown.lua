local M = {}

function M.setup()
  vim.g.nvim_markdown_preview_theme = 'github'
  if (vim.g.started_by_firenvim or 0) ~= 0 then
    vim.g.instant_markdown_autostart = 0
  end
end

return M

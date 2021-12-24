local M = {}

function M.setup()
  vim.g.firenvim_config = {
    globalSettings = { alt = 'all' },
    localSettings = {
      ['https?://[^/]+\\.(instagram\\.com|twitch\\.tv)'] = {
        takeover = 'never',
        priority = 1,
      },
    },
  }
end

return M

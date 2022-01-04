local M = {}

function M.run()
  vim.fn['firenvim#install'](0)
end

function M.setup()
  vim.g.firenvim_config = {
    globalSettings = { alt = 'all' },
    localSettings = {
      ['https?://[^/]+\\.(instagram\\.com|twitch\\.tv|notion\\.so)'] = {
        takeover = 'never',
        priority = 1,
      },
    },
  }
end

return M

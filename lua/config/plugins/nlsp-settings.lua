local _M = {}

function _M.config()
  local nlsp = require('nlspsettings')
  nlsp.setup({
    config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
    local_settings_dir = '.nlsp-settings',
    -- TODO: use project root
    local_settings_root_markers = { '.git', '.nlsp-settings' },
    append_default_schemas = false,
    loader = 'json',
  })
end

return _M

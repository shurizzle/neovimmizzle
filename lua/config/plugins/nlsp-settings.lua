local _M = {}

_M.lazy = true
_M.cmd = 'LspSettings'

function _M.config()
  local nlsp = require('nlspsettings')
  nlsp.setup({
    config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
    local_settings_dir = '.nlsp-settings',
    append_default_schemas = true,
    loader = 'json',
  })
end

return _M

local _M = {}

_M.cond = function() return not require('config.platform').is.headless end

function _M.config()
  local notify = require('notify')
  notify.setup({})
  vim.notify = notify
end

return _M

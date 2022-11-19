local _M = {}

_M.cond = function() return not is_headless() end

function _M.config()
  local notify = require('notify')
  notify.setup({})
  vim.notify = notify
end

return _M

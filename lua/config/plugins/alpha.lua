local _M = {}

function _M.config()
  require('alpha').setup(require('alpha.themes.dashboard').config)
end

return _M

local _M = {}

function _M.config()
  require('nvim-surround.config').default_opts.aliases = {}
  require('nvim-surround').setup()
end

return _M

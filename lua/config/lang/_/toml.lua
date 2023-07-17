local _M = {}

function _M.config()
  return require('config.lang.lsp').taplo:catch(
    function() return require('config.lang.fallback')('taplo') end
  )
end

return _M

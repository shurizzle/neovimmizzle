local _M = {}

function _M.config()
  return require('config.lang.lsp').jdtls:and_then(
    function() require('jdtls').start_or_attach({ cmd = { 'jdtls' } }) end
  )
end

return _M

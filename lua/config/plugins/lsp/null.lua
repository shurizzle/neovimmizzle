local _M = {}

_M.module_pattern = {
  '^null%-ls$',
  '^null%-ls%.',
}

function _M.config()
  require('null-ls').setup({ debug = false })
end

return _M

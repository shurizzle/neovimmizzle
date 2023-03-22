local _M = {}

_M.cmd = {
  'IlluminatePause',
  'IlluminateResume',
  'IlluminateToggle',
  'IlluminatePauseBuf',
  'IlluminateResumeBuf',
  'IlluminateToggleBuf',
}

function _M.init()
  require('illuminate').configure({
    filetypes_denylist = {
      'NvimTree',
      'dashboard',
      'alpha',
      'TelescopePrompt',
      'DressingInput',
    },
  })
end

return _M

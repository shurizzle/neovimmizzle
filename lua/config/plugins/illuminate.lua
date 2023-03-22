local _M = {}

_M.cmd = {
  'IlluminatePause',
  'IlluminateResume',
  'IlluminateToggle',
  'IlluminatePauseBuf',
  'IlluminateResumeBuf',
  'IlluminateToggleBuf',
}

_M.lazy = true

_M.event = 'VeryLazy'

function _M.config()
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

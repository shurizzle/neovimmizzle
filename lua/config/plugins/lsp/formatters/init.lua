local GeneratingMap = require('config.generating_map')
local Future = require('config.future')

return GeneratingMap.new(function(name)
  vim.validate({
    name = { name, 'string' },
  })
  return Future.pcall(require, 'config.plugins.lsp.formatters.' .. name)
end)

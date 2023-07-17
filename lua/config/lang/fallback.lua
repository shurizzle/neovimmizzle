local function which(...)
  for _, name in ipairs({ ... }) do
    if vim.fn.executable(name) ~= 0 then return name end
  end
end

return function(name, ...)
  local bins = { ... }
  if #bins == 0 then bins = { name } end

  local bin = which(unpack(bins))

  local Future = require('config.future')

  if bin == nil then
    return Future.rejected(name .. ': binary not found')
  else
    vim.notify(
      'Fallbacking to the system one',
      vim.log.levels.WARN,
      { title = name }
    )
    return Future.resolved(bin)
  end
end

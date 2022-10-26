local GeneratingMap = {}
GeneratingMap.__index = GeneratingMap

function GeneratingMap.new(generator)
  vim.validate({
    generator = { generator, 'function' },
  })

  local o = {
    generator = generator,
    map = {},
  }

  setmetatable(o, GeneratingMap)

  return o
end

function GeneratingMap.__index(self, index)
  if type(self.map[index]) == 'table' then
    return self.map[index][1]
  else
    self.map[index] = { self.generator(index) }
    return self.map[index][1]
  end
end

return GeneratingMap

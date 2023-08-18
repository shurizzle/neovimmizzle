(local GeneratingMap {})
(set GeneratingMap.__index GeneratingMap)

(fn GeneratingMap.new [generator]
  (vim.validate {:generator [generator :f]})

  (local o {: generator :map {}})
  (setmetatable o GeneratingMap)
  o)

(fn GeneratingMap.generating-map [generator]
  (GeneratingMap.new generator))

(fn GeneratingMap.__index [self index]
  (if (table? (. self.map index))
      (. self.map index 1)
      (let [res (self.generator index)]
        (tset self.map index [res])
        res)))

GeneratingMap

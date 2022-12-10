local Future = require('config.future')
local util = require('config.lang.util')

local _M = {}

_M.filetypes = {
  'haskell',
  'lhaskell',
  'cabal',
}

-- HINT:
-- ghcup compile hls -g master --ghc 9.2.5 -- -f 'cabal cabalfmt class callHierarchy eval importLens refineImports rename retrie hlint moduleName pragmas qualifyImportedNames codeRange changeTypeSignature explicitFixity explicitFields fourmolu refactor'

function _M.config()
  return Future.pcall(function()
    local ok1, res1 = pcall(util.packer_load, 'haskell-tools.nvim')

    if not ok1 then print(res1) end
    require('haskell-tools').setup({
      hls = {
        filetypes = {
          'haskell',
          'lhaskell',
          'cabal',
        },
      },
    })
  end)
end

return _M

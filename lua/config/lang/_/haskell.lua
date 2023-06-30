local Future = require('config.future')
local util = require('config.lang.util')

local _M = {}

_M.filetypes = {
  'haskell',
  'lhaskell',
  'cabal',
}

-- NOTE:
--! cabal update
-- ghcup compile hls -g 1.8.0.0 --ghc 9.2.5 -- -f 'cabal cabalfmt class callHierarchy eval importLens refineImports rename retrie hlint moduleName pragmas qualifyImportedNames codeRange changeTypeSignature explicitFixity explicitFields fourmolu refactor'
-- ghcup compile hls -g 1.9.0.0 --ghc 9.2.5 -- -f 'cabal class callHierarchy haddockComments eval importLens refineImports rename retrie tactic hlint stan moduleName pragmas splice alternateNumberFormat qualifyImportedNames codeRange changeTypeSignature gadt explicit Fixity explicitFields fourmolu refactor dynamic cabalfmt'
-- ghcup compile hls -g 1.10.0.0 --ghc 9.2.7 -- -f 'cabal class callHierarchy haddockComments eval importLens refineImports rename retrie tactic hlint stan moduleName pragmas splice alternateNumberFormat qualifyImportedNames codeRange changeTypeSignature gadt explicitFixity explicitFields fourmolu refactor dynamic cabalfmt'
-- ghcup compile hls -g 1.10.0.0 --ghc 9.2.8 -- -f 'cabal class callHierarchy haddockComments eval importLens refineImports rename retrie tactic hlint stan moduleName pragmas splice alternateNumberFormat qualifyImportedNames codeRange changeTypeSignature gadt explicitFixity explicitFields fourmolu refactor dynamic cabalfmt'
-- ghcup compile hls -g 2.0.0.1 --ghc 9.2.8 -- -f 'cabal class callHierarchy haddockComments eval importLens refineImports rename retrie tactic hlint stan moduleName pragmas splice alternateNumberFormat qualifyImportedNames codeRange changeTypeSignature gadt explicitFixity explicitFields overloadedRecordDot fourmolu refactor dynamic cabalfmt'

function _M.config()
  return Future.pcall(
    function()
      require('haskell-tools').setup({
        hls = {
          filetypes = {
            'haskell',
            'lhaskell',
            'cabal',
          },
        },
      })
    end
  )
end

return _M

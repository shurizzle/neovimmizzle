; NOTE:
;! cabal update
; ghcup compile hls -g 2.2.0.0 --ghc 9.2.8 -- -f 'cabal class callHierarchy haddockComments eval importLens refineImports rename retrie tactic hlint stan moduleName pragmas splice alternateNumberFormat qualifyImportedNames codeRange changeTypeSignature gadt explicitFixity explicitFields overloadedRecordDot fourmolu refactor dynamic cabalfmt'

{:filetypes [:haskell :lhaskell :cabal]
 :config (fn []
           ((. (require :haskell-tools) :setup)
            {:hls {:filetypes [:haskell :lhaskell :cabal]}}))}

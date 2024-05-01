(fn init []
  (set vim.g.haskell_tools
       {:hls {:filetypes [:haskell :lhaskell :cabal :cabalproject]
              :settings {:haskell {:formattingProvider :fourmolu}}}}))

{:lazy false : init}

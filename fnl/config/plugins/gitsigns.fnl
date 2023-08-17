{:lazy true
 :event :BufRead
 :dependencies [:nvim-lua/plenary.nvim]
 :config (fn [] ((. (require :gitsigns) :setup) []))}

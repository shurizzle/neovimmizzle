{:lazy true
 :event :BufRead
 :config (fn [] ((. (require :todo-comments) :setup) []))}

(fn config []
  ((. (require :osc52) :setup) {:max_length 0
                                :silent false
                                :trim false}) 
  (fn copy [lines _] ((. (require :osc52) :copy) (table.concat lines "\n")))
  (fn paste []
    [(icollect [l (vim.gsplit (vim.fn.getreg "") "\n" {:trimempty false})] l)
     (vim.fn.getregtype "")])
  (set vim.g.clipboard {:name  :osc52
                        :copy  {:+ copy :* copy}
                        :paste {:+ paste :* paste}}))

{:cond (. (require :config.platform) :is :ssh)
 : config}

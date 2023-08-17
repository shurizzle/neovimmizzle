{:lazy true
 :config (fn []
           ((. (require :nvim-treesitter.configs) :setup)
            {:context_commentstring {:enable true
                                     :enable_autocmd false}}))}

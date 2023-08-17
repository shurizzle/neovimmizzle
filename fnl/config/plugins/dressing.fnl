{:lazy true
 :event :VeryLazy
 :config (fn []
           ((. (require :dressing) :setup) {:input {:insert_only false
                                                    :win_options {:winblend 20}}}))}

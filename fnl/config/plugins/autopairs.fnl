{:lazy true
 :event :InsertEnter
 :config (fn []
           (let [npairs (require :nvim-autopairs)
                 Rule   (require :nvim-autopairs.rule)]
             (npairs.setup)
             (npairs.add_rule (: (Rule :< :> :rust) :with_pair
                                 ((. (require :nvim-autopairs.conds) :is_bracket_line))))))}

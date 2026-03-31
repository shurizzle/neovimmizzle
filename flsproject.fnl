{:fennel-path "./fnl/?.fnl;./fnl/?/init.fnl"
 :macro-path "./?.fnl;./?/init-macros.fnl;./?/init.fnl;src/?.fnl;src/?/init-macros.fnl;src/?/init.fnl"
 :lua-version :lua51
 :libraries {:nvim true}
 :extra-globals "vim inc! dec! autoload lazy-var lazy-let module matches nil? number? boolean? string? table? function? keys vals empty? count inc dec even? odd? identity some const triml trimr trim copy starts-with? strip-prefix ends-with? strip-suffix slurp once unpack readonly-table has inspect term-run executable exepath"
 :lints {:unnecessary-do true
         :multival-in-middle-of-call true
         :bad-unpack true
         :duplicate-table-keys true
         :empty-do true
         :empty-let true
         :inline-unpack true
         :invalid-flsproject-settings true
         :legacy-multival true
         :legacy-multival-case true
         :match-should-case true
         :nested-associative-operator true
         :no-decreasing-comparison true
         :not-enough-arguments true
         :op-with-no-arguments true
         :redundant-do true
         :too-many-arguments true
         :unknown-module-field true
         :unnecessary-method true
         :unnecessary-tset true
         :unnecessary-unary true
         :unused-definition true
         :var-never-set true
         :zero-indexed true}}

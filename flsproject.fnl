{:fennel-path "./fnl/?.fnl;./fnl/?/init.fnl"
 :macro-path "./?.fnl;./?/init-macros.fnl;./?/init.fnl;src/?.fnl;src/?/init-macros.fnl;src/?/init.fnl"
 :lua-version :lua54
 :libraries {:love2d false :tic-80 false}
 :extra-globals "vim inc! dec! autoload lazy-var lazy-let module matches nil? number? boolean? string? table? function? keys vals empty? count inc dec even? odd? identity some const triml trimr trim copy starts-with? strip-prefix ends-with? strip-suffix slurp once unpack readonly-table has inspect term-run executable exepath"
 :lints {:unused-definition true
         :unknown-module-field true
         :unnecessary-method true
         :bad-unpack true
         :var-never-set true
         :op-with-no-arguments true
         :multival-in-middle-of-call true}}

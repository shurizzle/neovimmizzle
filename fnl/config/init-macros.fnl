;; fennel-ls: macro-file

(fn inc! [varname]
  (assert-compile (sym? varname) "Invalid variable name" varname)
  `(set ,varname (+ ,varname 1)))

(fn dec! [varname]
  (assert-compile (sym? varname) "Invalid variable name" varname)
  `(set ,varname (- ,varname 1)))

(fn chunks2 [seq]
  (lambda next [seq ?index]
    (if (and (not= nil ?index) (or (not= :number (type ?index)) (< ?index 0)))
        (error "invalid ?index parameter"))
    (let [index (or ?index 0)
          base (+ 1 (* 2 index))
          index (+ 1 index)]
      (when (<= base (length seq))
        (values index [(. seq base) (. seq (+ 1 base))]))))
  (values next seq 0))

(fn transform-sym [bind lib]
  (let [ensure (gensym)]
    [`(var ,bind nil)
     `(fn ,ensure
        []
        (let [required# ,lib]
          (set ,bind required#)
          required#))
     `(set ,bind
           (setmetatable {} ; TODO: map more metamethods
                         {:__call (fn [_# ...]
                                    ((,ensure) ...))
                          :__index (fn [_# k#]
                                     (. (,ensure) k#))
                          :__newindex (fn [_# k# v#]
                                        (tset (,ensure) k# v#))
                          :__tostring (fn [_#]
                                        (tostring (,ensure)))}))]))

(fn copy [v]
  (icollect [_ v (ipairs v)] v))

(fn merge! [a b]
  (each [_ v (ipairs b)]
    (table.insert a v))
  a)

(fn merge [a b] (merge! (copy a) b))

(fn extract-symbols [t pref res]
  (if (sym? t)
      (tset res t pref)
      (or (table? t) (sequence? t))
      (each [k v (pairs t)]
        (extract-symbols v (merge (copy pref) [k]) res))
      (assert-compile false "invalid binding structure" t)))

(fn lazy-bind-table [t expr]
  (var symbols [])
  (var res [])
  (extract-symbols t [] symbols)
  (each [name path (pairs symbols)]
    (each [_ v (ipairs (transform-sym name `(. ,expr ,(unpack path))))]
      (table.insert res v)))
  res)

(fn transform-table [t expr]
  (let [lib-sym (gensym)]
    (var res (lazy-bind-table t lib-sym))
    (var main-lib (transform-sym lib-sym expr))
    (for [i (length main-lib) 1 -1]
      (table.insert res 1 (. main-lib i)))
    res))

(fn transform [bind expr]
  (if (sym? bind)
      (transform-sym bind expr)
      (or (table? bind) (sequence? bind))
      (transform-table bind expr)
      (assert-compile false "invalid binding structure" bind)))

(fn lazy-bind [bindings transform]
  (assert-compile (sequence? bindings) "invalid arguments for autoload"
                  bindings)
  (assert-compile (and (= 0 (% (length bindings) 2)) (not= 0 (length bindings)))
                  "invalid arguments for autoload" bindings)
  (var res [])
  (each [_ [bind lib] (chunks2 bindings)]
    (each [_ x (ipairs (transform bind lib))]
      (table.insert res x)))
  (list `eval (unpack res)))

(fn autoload-transform [bind lib]
  (transform bind `(require ,lib)))

(fn autoload [bindings]
  (lazy-bind bindings autoload-transform))

(fn lazy-var [bindings]
  (lazy-bind bindings transform))

(fn lazy-let [bindings ...]
  `(do
     ,(lazy-var bindings)
     ,...))

(local *mod-mappings* {:def :var :def- :var :defn :lambda :defn- :lambda})

(fn transform-expression [mod-sym expr]
  (if (list? expr)
      (let [call-name (-?> (. expr 1) (tostring))
            rep-name (-?>> call-name (. *mod-mappings*) (sym))
            name (. expr 2)]
        (if rep-name
            (do
              (assert-compile (sym? name) (.. "Invalid " call-name " syntax")
                              name)
              (tset expr 1 rep-name)
              (if (or (= call-name :def) (= call-name :defn))
                  [expr `(tset ,mod-sym ,(tostring name) ,name)]
                  [expr]))
            [expr]))
      [expr]))

(fn module [& exprs]
  (let [mod-sym (gensym)
        mod []]
    (each [_ expr (ipairs exprs)]
      (each [_ new-expr (ipairs (transform-expression mod-sym expr))]
        (table.insert mod new-expr)))
    (table.insert mod mod-sym)
    `(let [,mod-sym []]
       ,mod
       ,mod-sym)))

(fn matches [v cond]
  `(match ,v
     (where ,cond) true
     _# false))

{: inc! : dec! : autoload : lazy-var : lazy-let : module : matches}


(fn type? [o]
  (or (= :formatters o) (= :linters o) (= :lsp o)))

(fn string? [o]
  (= :string (type o)))

(fn pull-optional [args]
  (if (sym? (. args 1))
    (if (= :? (tostring (. args 1)))
        (do
          (table.remove args 1)
          true)
        (assert-compile false "Invalid symbol" (. args 1)))
    false))

(fn pull-name [state args]
  (assert-compile (not= 0 (length args)) (.. "Missing " state " name") args)
  (local optional (pull-optional args))
  (assert-compile (not= 0 (length args)) (.. "Missing " state " name") args)
  (local name (if (string? (. args 1))
                  (table.remove args 1)
                  (assert-compile false "Invalid name" (. args 1))))
  {: name : optional})

(fn pull-name-next [state args]
  (if (not= 0 (length args))
      (let [optional (pull-optional args)]
        (assert-compile (not= 0 (length args)) (.. "Missing " state " name") args)

        (local name (match (. args 1)
                      (where name (string? name))
                        (when (not (type? name))
                          (table.remove args 1))
                      _ (do
                          (assert-compile (not optional) "Invalid name" (. args 1))
                          false)))

        (assert-compile (not (and (not name) optional))
                        "Invalid name following optional sign" args)

        (when name
          {: name : optional}))))

(fn merge-optional [a b ...]
  (let [res (if
              (= nil a) b
              (= nil b) a
              (and a b))]
    (if (> (select :# ...) 0)
        (merge-optional res ...)
        res)))

(fn pull-block [args res]
  (if (type? (. args 1))
      (do
        (var typ (table.remove args 1))
        (let [{: name : optional} (pull-name typ args)
              opt (merge-optional (. res typ name) optional)]
          (tset (. res typ) name opt))
        (while (match (pull-name-next typ args)
                 {: name : optional}
                   (let [opt (merge-optional (. res typ name) optional)]
                     (tset (. res typ) name opt)
                     true)))
        true)
      false))

(fn empty? [xs]
  "Returns true if the arguments is empty."
  (if
    (= :table (type xs)) (not (next xs))
    (not xs) true
    (= 0 (length xs))))

(fn wrap-requires [state {: f : l : lsp} body]
  (let [let-bindings []]
    (when (not (empty? state.formatters))
      (table.insert let-bindings f)
      (table.insert let-bindings `(require :config.lang.formatters)))
    (when (not (empty? state.linters))
      (table.insert let-bindings l)
      (table.insert let-bindings `(require :config.lang.linters)))
    (when (not (empty? state.lsp))
      (table.insert let-bindings lsp)
      (table.insert let-bindings `(require :config.lang.lsp)))
    (if (not (empty? let-bindings))
      `(let ,let-bindings ,body)
      body)))

(fn make-checks [{: resolved : rejected : res} needed]
  (if (empty? needed)
      `(,resolved nil)
      (do
        (var branches [])
        (each [_ i (ipairs needed)]
          (table.insert branches `(not (. ,res ,i 1)))
          (table.insert branches `(,rejected (. ,res ,i 2))))
        (table.insert branches `(,resolved nil))
        `(if ,(unpack branches)))))

(fn compose-body [{: f-join : resolved : rejected : res} futures needed]
  `(let [{:join     ,f-join
          :resolved ,resolved
          :rejected ,rejected} (require :config.future)]
     (: ,futures :and-then
        (fn [,res]
          ,(make-checks {: f-join : resolved : rejected : res} needed)))))

(fn single-requirement [state]
  (fn only-one [name map]
    (let [(k v) (next map)]
      (if (not (next map k))
          (values name k v))))

  (if
    (and (empty? state.formatters) (empty? state.linters))
      (only-one :lsp state.lsp)
    (and (empty? state.formatters) (empty? state.lsp))
      (only-one :linters state.linters)
    (and (empty? state.linters) (empty? state.lsp))
      (only-one :formatters state.formatters)))

(fn compose-futures [state symbols]
  (let [(typ name optional) (single-requirement state)]
    (if (and typ name (not optional))
        (let [{: f : l : lsp} symbols
              what (match typ
                     :lsp lsp
                     :linters l
                     :formatters f)]
          `(. ,what ,name))
        (let [{: f : l : lsp : f-join} symbols]
          (var futures [])
          (var needed [])

          (each [name optional (pairs state.formatters)]
            (table.insert futures `(. ,f ,name))
            (if (not optional)
                (table.insert needed (length futures))))
          (each [name optional (pairs state.linters)]
            (table.insert futures `(. ,l ,name))
            (if (not optional)
                (table.insert needed (length futures))))
          (each [name optional (pairs state.lsp)]
            (table.insert futures `(. ,lsp ,name))
            (if (not optional)
                (table.insert needed (length futures))))

          (compose-body symbols `(,f-join ,futures) needed)))))

(fn body [state]
  (let [f-join (gensym)
        resolved (gensym)
        rejected (gensym)
        f (gensym)
        l (gensym)
        lsp (gensym)
        res (gensym)
        symbols {: f-join : resolved : rejected : f : l : lsp : res}]
    (wrap-requires state symbols (compose-futures state symbols))))

(fn config [...]
  (var args [...])
  (assert-compile (not= 0 (length args)) "Invalid arguments for config" args)
  (local name (when (sym? (. args 1))
                (table.remove args 1)))
  (assert-compile (not= 0 (length args)) "Invalid arguments for config" args)
  (assert-compile (type? (. args 1)) "Invalid required type" (. args 1))
  (var state {:formatters [] :linters [] :lsp []})
  (while (pull-block args state))

  (var gen-body (body state))
  (when (not (empty? args))
    (set gen-body `(: ,gen-body :and-then
                     (fn [] ,(unpack args)))))
  (if name
      `(fn ,name [] ,gen-body)
      `(fn [] ,gen-body)))

{: config}

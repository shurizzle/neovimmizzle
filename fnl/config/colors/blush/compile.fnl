(fn some [f haystack]
  (each [k v (pairs haystack)]
    (when (f v k haystack)
      (lua "return v"))))

(local *keys* [:fg :bg :bold :italic :underline :reverse])

(local {: view} (require :fennel))
(local {: name-beauty} (require :config.colors.blush.color))

(fn merge! [a b]
  (each [k v (pairs b)]
    (tset a k (. b k)))
  a)

(fn list-link? [value]
  (when (= nil (. value 1))
    (lua "return false"))
  (each [k _ (pairs value)]
    (when (not= 1 k)
      (lua "return false")))
  true)

(fn validate-name [name]
  (when (or (not= :string (type name))
            (not (string.match name "^[a-zA-Z0-9_.@]*$")))
    (error (.. "invalid name " (view name))))
  name)

(fn validate-def-keys [name def]
  (when (not= :table (type def))
    (error (.. "invalid definition of " name ": " (view def))))
  (each [k _ (pairs def)]
    (match (type k)
      (where :number) (if (< k 1)
                          (error (.. "invalid key " k " in group " name))
                          (and (not= 1 k) (= nil (. def (- k 1))))
                          (error (.. "invalid value for key " (- k 1)
                                     " in group " name)))
      (where :string) (when (not (some (partial = k) *keys*))
                        (error (.. "invalid key " k " in group " name)))
      _ (error (.. "invalid key " (view k) " in group " name)))))

(fn validate-bool [name key value]
  (when (and (not= nil value) (not= :boolean (type value)))
    (error "invalid value " (view value) " for key " key " in group " name))
  value)

(fn unwrap-option [value]
  (fn option? [value]
    (if (= :table (type value))
        (do
          (each [k _ (pairs value)]
            (when (not= 1 k)
              (lua "return false")))
          true)
        false))

  (if (option? value)
      (. value 1)
      value))

(fn validate-rgb [name key value]
  (local x "[a-fA-F0-9]")
  (local *3pat (.. "^(" x ")(" x ")(" x ")$"))
  (local *6pat (.. "^(" x x ")(" x x ")(" x x ")$"))

  (fn match-pattern [value pattern compose]
    (let [(r g b) (string.match value pattern)]
      (when (and r g b)
        (compose r g b))))

  (fn recompose [r g b]
    (.. "#" r g b))

  (fn recompose3 [r g b]
    (recompose (.. r r) (.. g g) (.. b b)))

  (fn match6 [value]
    (match-pattern value *6pat recompose))

  (fn match3 [value]
    (match-pattern value *3pat recompose3))

  (local value* (if (= "#" (value:sub 1 1))
                    (value:sub 2)
                    value))
  (or (match6 value*) (match3 value*)
      (error (.. "invalid color " (view value) " for key " key " in group "
                 name))))

(fn validate-color [name key value]
  (when (= nil value)
    (lua "return nil"))
  (let [value (unwrap-option value)]
    (if value
        (let [value (tostring value)
              name* (name-beauty value)]
          [(or name* (validate-rgb name key value))])
        [])))

(var resolve nil)
(fn resolve* [state name]
  (var value (. state.defs name))
  (if (= :string (type value))
      (do
        (validate-name value)
        (resolve state value)
        {:link value})
      (and (= :table (type value)) (list-link? value))
      (let [name (validate-name (. value 1))]
        (resolve state name)
        {:link name})
      (do
        (validate-def-keys name value)
        (local overrides
               {:bg (validate-color name :bg value.bg)
                :fg (validate-color name :fg value.fg)
                :italic (validate-bool name :italic value.italic)
                :bold (validate-bool name :bold value.bold)
                :underline (validate-bool name :underline value.underline)
                :reverse (validate-bool name :reverse value.reverse)})
        (var res nil)
        (each [_ v (ipairs value)]
          (set res (merge! (or res []) (resolve state v))))
        (if res
            (merge! res overrides)
            overrides))))

(set resolve (fn [state name]
               (each [_ k (ipairs state.stack)]
                 (when (= name k)
                   (error (.. "circular dependecy in " name))))
               (table.insert state.stack name)
               (let [res (resolve* state name)]
                 (table.remove state.stack (length state.stack))
                 (tset state.resolved name res)
                 res)))

(fn compile* [colors]
  (local state {:stack [] :resolved [] :defs colors})
  (each [k _ (pairs colors)]
    (validate-name k)
    (when (= nil (. state.resolved k))
      (resolve state k)))
  state.resolved)

(fn merge-def [def]
  (if def.link
      def
      (let [res {:bg (-?> def.bg (. 1)) :fg (-?> def.fg (. 1))}]
        (each [_ k (ipairs [:bold :italic :underline :reverse])]
          (when (. def k)
            (if res.gui
                (set res.gui (.. res.gui "," k))
                (set res.gui k))))
        res)))

(fn compile [colors]
  (local compiled (compile* colors))
  (local keys (icollect [k _ (pairs compiled)] k))
  (table.sort keys)
  (local res [])
  (each [_ k (ipairs keys)]
    (table.insert res [k (merge-def (. compiled k))]))
  res)

{: compile}

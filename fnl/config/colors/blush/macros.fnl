(local unpack (or table.unpack _G.unpack))
(local *flags* [:bold :italic :underline])

(fn make-iterator [list]
  {:inner list
   :max   (length list)
   :next  1})

(fn iter-next [iter]
  (if (> iter.next iter.max)
      false
      (let [e (. iter.inner iter.next)]
        (set iter.next (+ 1 iter.next))
        (values true e))))

(fn some [f haystack]
  (each [k v (pairs haystack)]
    (when (f v k haystack)
      (lua "return v"))))

(fn rule [rule]
  (assert-compile (list? rule) "rule must be a list" rule)
  (assert-compile (> (length rule) 0) "rule must be a non-empty list" rule)
  (var iter (make-iterator rule))
  (var name (let [(exists? name) (iter-next iter)]
              (assert-compile (and exists?
                                   (or (sym? name) (= :string (type name))))
                              "rule name must be a symbol or a string" name)
              name))
  (set name (tostring name))
  (var opts [])
  (fn set-opt [name value]
    (assert-compile (= nil (. opts name)) (.. "duplicated option " name) name)
    (tset opts name value))
  (fn set-flag [name value]
    (assert-compile (some (partial = name) *flags*) (.. "invalid flag " name))
    (set-opt name value))
  (fn add-parent [name]
    (each [_ v (ipairs opts)]
      (assert-compile (not= v name) (.. name " inherited multiple times")))
      (table.insert opts name))

  (var key nil)
  (while (let [(exists? name) (iter-next iter)]
           (set key (if exists? name nil))
           exists?)
    (assert-compile (or (= :string (type key)) (sym? key))
                    "unknown property" key)
    (if
      (sym? key) (let [key (tostring key)]
                   (match (key:sub 1 1)
                     (where :-) (set-flag (key:sub 2) false)
                     (where :+) (set-flag (key:sub 2) true)
                     _ (add-parent key)))
      (or (= :fg key) (= :bg key))
        (let [(exists? value) (iter-next iter)]
          (assert-compile exists? (.. "needed value for key " key) key)
          (tset opts key [value]))
      (add-parent key)))
  (values name opts))

(fn blush [& rules]
  (var res [])
  (each [_ r (pairs rules)]
    (let [(name value) (rule r)]
      (assert-compile (= nil (. res name))
                      (.. "rule " name " defined multiple times") r)
      (tset res name value)))
  res)

{: blush}

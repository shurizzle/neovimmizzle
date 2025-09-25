(fn filter [f iter]
  (fn []
    (var res nil)

    (fn step []
      (let [args [(iter)]]
        (if (= 0 (length args))
            false
            (if (f (unpack args))
                (do
                  (set res args) false)
                true))))

    (while (step))
    (when res
      (unpack res))))

(fn map [f iter]
  (fn []
    (let [args [(iter)]]
      (if (= 0 (length args))
          nil
          (f (unpack args))))))

(fn filter-map [f iter]
  (fn []
    (var res nil)

    (fn step []
      (let [args [(iter)]]
        (if (= 0 (length args))
            false
            (let [r [(f (unpack args))]]
              (if (= 0 (length r)) true
                  (do
                    (set res r) false))))))

    (while (step))
    (when res
      (unpack res))))

(fn split [haystack pattern]
  (var cursor 1)
  (fn []
    (when (<= cursor (length haystack))
      (case (string.find haystack pattern cursor)
        nil (let [res (string.sub haystack cursor)]
              (set cursor (+ 1 (length haystack)))
              res)
        (end new-start) (let [res (string.sub haystack cursor (- end 1))]
                          (set cursor (+ 1 new-start))
                          res)))))

{: filter : map : filter-map : split}

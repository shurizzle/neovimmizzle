(local HEXMAP {:0 0
               :1 1
               :2 2
               :3 3
               :4 4
               :5 5
               :6 6
               :7 7
               :8 8
               :9 9
               :a 10
               :A 10
               :b 11
               :B 11
               :c 12
               :C 12
               :d 13
               :D 13
               :e 14
               :E 14
               :f 15
               :F 15})

(fn parse4 [str]
  "Parse IPv4"
  (vim.validate {:str [str :s]})

  (let [octects [(str:match "^(%d?%d?%d)%.(%d?%d?%d)%.(%d?%d?%d)%.(%d?%d?%d)$")]]
    (when (and (= (length octects) 4)
               (not= :break
                     (some (fn [raw i l]
                             (let [value (tonumber raw)]
                               (if (and (number? value) (<= value 255))
                                   (do
                                     (tset l i value)
                                     false)
                                   :break)))
                           octects)))
        octects)))

(fn hex->int [hex]
  (vim.validate {:hex [hex :s]})
  (var res 0)
  (for [i 1 (length hex)]
    (let [v (. HEXMAP (hex:sub i i))]
      (if (not= nil v)
          (set res (+ (* res 16) v))
          (lua "return"))))
  res)

(fn convert-ipv4 [str]
  (vim.validate {:str [str :s]})
  (let [(i j) (str:find ":%d?%d?%d%.%d?%d?%d%.%d?%d?%d%.%d?%d?%d$")]
    (if i
      (let [ipv4 (parse4 (str:sub (+ i 1) j))]
        (when ipv4
          (.. (str:sub 0 i)
              (string.format :%x:%x
                             (bor (lshift (. ipv4 1) 8) (. ipv4 2))
                             (bor (lshift (. ipv4 3) 8) (. ipv4 4))))))
      str)))

(fn nil-if-empty [x]
  (if (empty? x) nil x))

(fn parse-bits [str ?collected]
  (vim.validate {:str        [str        :s]
                 :?collected [?collected :t true]})

  (let [matches (str:match "^(%x?%x?%x?%x)")]
    (if matches
      (let [piece (hex->int matches)]
        (when piece
          (let [len (match (+ (length matches) 1)
                      (where n (= (str:sub n n) ::)) (+ n 1)
                      other other)
                rest (nil-if-empty (str:sub len))
                acc (if ?collected ?collected [])]
            (table.insert acc piece)
            (if str
              (parse-bits rest acc)
              acc)))))))

(fn parse6 [str]
  (vim.validate {:str [str :s]})
  (var str (convert-ipv4 str))
  (when str
    (let [(head0 tail0) (let [(i j) (str:find :::)]
                          (if i
                              (values (nil-if-empty (if (= i 1) "" (str:sub 0 (- i 1))))
                                      (nil-if-empty (str:sub (+ j 1))))
                              (values str nil)))
           head (if head0 (parse-bits head0) [])
           tail (if tail0 (parse-bits tail0) [])]
      (when (and head tail)
        (for [_ 1 (- 8 (+ (length head) (length tail)))]
          (table.insert head 0))
        (each [_ value (ipairs tail)]
          (table.insert head value))
        head))))

(fn parse [str]
  (vim.validate {:str [str :s]})
  (match (parse4 str)
    nil (parse6 str)
    other other))

{: parse4
 : parse6
 : parse}

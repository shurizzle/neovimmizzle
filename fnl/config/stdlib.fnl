(fn nil? [x]
  "True if the value is equal to `nil`."
  (= nil x))

(fn number? [x]
  "True if the value is of type 'number'."
  (= :number (type x)))

(fn boolean? [x]
  "True if the value is of type 'boolean'."
  (= :boolean (type x)))

(fn string? [x]
  "True if the value is of type 'string'."
  (= :string (type x)))

(fn table? [x]
  "True if the value is of type 'table'."
  (= :table (type x)))

(fn function? [x]
  "True if the value is of type 'function'."
  (= :function (type x)))

(fn keys [t]
  "Get all keys of a table."
  (vim.tbl_keys t))

(fn vals [t]
  "Get all values of a table."
  (vim.tbl_values t))

(fn empty? [xs]
  "Returns true if the arguments is empty."
  (if
    (table? xs) (vim.tbl_isempty xs)
    (not xs) true
    (= 0 (length xs))))

(fn inc [n]
  "Increment n by 1."
  (+ n 1))

(fn dec [n]
  "Decrement n by 1."
  (- n 1))

(fn even? [n]
  (= (% n 2) 0))

(fn odd? [n]
  (not= (% n 2) 0))

(fn identity [x]
  "Returns what you pass it."
  x)

(fn some [f xs]
  "Return the first truthy result from (f x) or nil."
  (each [_ x (pairs xs)]
    (var result (f x))
    (if result (lua "return result")))
  nil)

(fn const [v]
  (fn [] v))

(fn triml [s]
  "Removes whitespaces from the left side of string."
  (string.gsub s "^%s*(.-)" "%1"))

(fn trimr [s]
  "Removes whitespaces from the right side of string."
  (string.gsub s "(.-)%s*$" "%1"))

(fn trim [s]
  "Removes whitespaces from both ends of string."
  (string.gsub s "^%s*(.-)%s*$" "%1"))

{: nil?
 : number?
 : boolean?
 : string?
 : table?
 : function?
 : keys
 : vals
 : empty?
 : inc
 : dec
 : even?
 : odd?
 : identity
 : some
 : const
 : triml
 : trimr
 : trim}

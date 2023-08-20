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

(fn count [xs]
  "Returns the number of elments in object."
  (if
    (table? xs) (vim.tbl_count xs)
    (not xs) 0
    (length xs)))

(fn inc [n]
  "Increment n by 1."
  (+ n 1))

(fn dec [n]
  "Decrement n by 1."
  (- n 1))

(fn even? [n]
  "True if the value is even."
  (= (% n 2) 0))

(fn odd? [n]
  "True if the value is odd."
  (not= (% n 2) 0))

(fn identity [x]
  "Returns what you pass it."
  x)

(fn some [f xs]
  "Returns the first truthy result from (f x) or nil."
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

(fn copy [x]
  "Returns a deep copy of the given object."
  (vim.deepcopy x))

(fn starts-with? [s prefix]
  "True if string `s` starts with string `prefix`."
  (vim.startswith s prefix))

(fn strip-prefix [s prefix]
  "Returns string `s` without string `prefix` if `s` starts with `prefix`, else
  returns nil."
  (when (starts-with? s prefix)
    (string.sub s (inc (length prefix)))))

(fn ends-with? [s suffix]
  "True if string `s` ends with string `suffix`."
  (vim.endswith s suffix))

(fn strip-suffix [s suffix]
  "Returns string `s` without string `suffix` if `s` ends with `suffix`, else
  returns nil."
  (when (ends-with? s suffix)
    (string.sub s 1 (- (length s) (length suffix)))))

(fn slurp [path]
  "Read the file into a string."
  (match (io.open path "r")
    (nil _msg) nil
    f (let [content (f:read "*all")]
        (f:close)
        content)))

(fn once [f]
  (vim.validate {:f [f :f]})
  (var called false)
  (fn [...]
    (when (not called)
      (set called true)
      (f ...))))

{: nil?
 : number?
 : boolean?
 : string?
 : table?
 : function?
 : keys
 : vals
 : empty?
 : count
 : inc
 : dec
 : even?
 : odd?
 : identity
 : some
 : const
 : triml
 : trimr
 : trim
 : copy
 : starts-with?
 : strip-prefix
 : ends-with?
 : strip-suffix
 : slurp
 : once}

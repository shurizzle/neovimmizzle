[
 (string)
 (glob)
 (user)
 (group)
] @string

(string_expansion) @embedded

(variable_name) @constant

(exec_rule . "rule" @keyword)

[
 (askpass)
 (keepenv)
 (origin)
 (target)
 (timeout)
 (setenv)
 (exe)
] @function.builtin

(bool) @boolean

(u64) @number

[
 (or)
 (minus)
 (assign)
 (colon)
] @operator

(comment) @comment

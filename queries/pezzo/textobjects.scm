(statement value: (_) @function.inner) @function.outer

((exec_rule
   body: (exec_body
           brace_open: (_) @_start
           brace_close: (_) @_end)) @class.outer
 (#make-range! "class.inner" @_start @_end))

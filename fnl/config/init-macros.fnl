(fn inc! [varname]
  (assert-compile (sym? varname) "Invalid variable name" varname)
  `(set ,varname (+ ,varname 1)))

(fn dec! [varname]
  (assert-compile (sym? varname) "Invalid variable name" varname)
  `(set ,varname (- ,varname 1)))

{: inc!
 : dec!}

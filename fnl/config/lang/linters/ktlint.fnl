(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :ktlint) :and-then
     (fn [] (register builtins.diagnostics.ktlint))))

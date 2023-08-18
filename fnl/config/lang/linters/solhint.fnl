(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :solhint) :and-then
     (fn [] (register builtins.diagnostics.solhint))))

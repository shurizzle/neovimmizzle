(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :staticcheck) :and-then
     (fn [] (register builtins.diagnostics.staticcheck))))

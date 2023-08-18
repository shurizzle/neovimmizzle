(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :shellcheck) :and-then
     (fn [] (register builtins.diagnostics.shellcheck))))

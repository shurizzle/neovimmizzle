(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :black) :and-then
     (fn [] (register builtins.formatting.black))))

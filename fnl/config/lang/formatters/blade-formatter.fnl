(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :blade-formatter) :and-then
     (fn [] (register builtins.formatting.blade_formatter))))

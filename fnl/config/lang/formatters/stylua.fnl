(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :stylua) :and-then
     (fn [] (register builtins.formatting.stylua))))

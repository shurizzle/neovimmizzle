(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :shfmt) :and-then
     (fn [] (register builtins.formatting.shfmt))))

(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :beautysh) :and-then
     (fn []
       (register (builtins.formatting.beautysh.with {:extra_args [:-i2]})))))


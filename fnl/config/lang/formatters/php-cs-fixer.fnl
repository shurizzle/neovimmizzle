(local rules "@PSR12,ordered_imports,no_unused_imports")

(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :php-cs-fixer) :and-then
     (fn [] (register (builtins.formatting.phpcsfixer.with
                        {:extra_args [(.. "--rules=" rules)]})))))

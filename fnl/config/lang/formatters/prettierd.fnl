(let [{: register : builtins} (require :null-ls)]
  (: (. (require :config.lang.installer) :prettierd) :and-then
     (fn [] (register (builtins.formatting.prettierd.with
                        {:extra_filetypes [:svelte]})))))

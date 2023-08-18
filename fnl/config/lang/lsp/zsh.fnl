(let [{:pcall f-pcall} (require :config.future)
      {: register : builtins} (require :null-ls)]
  (f-pcall (fn [] (register builtins.diagnostics.zsh))))

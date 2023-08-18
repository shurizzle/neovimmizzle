(let [{: join : and-then : resolved : rejected} (require :config.future)
      installer (require :config.lang.installer)]
  (and-then
    (join [installer.ocaml-lsp installer.ocamlformat])
    (fn [[[ok err] & _]]
      (if ok
          (do
            ((. (require :lspconfig) :ocamllsp :setup) [])
            (resolved nil))
          (rejected err)))))

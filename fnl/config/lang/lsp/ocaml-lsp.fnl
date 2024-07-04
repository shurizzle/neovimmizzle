(local {:join path-join} (require :config.path))
(local installer (require :config.lang.installer))
(local {: bin-or-install} (require :config.lang.util))
(local lspconfig (require :lspconfig))

(fn config [bin fmt]
  (local opts [])
  (when bin (set opts.cmd [bin :--stdio]))
  (when fmt
    (local path (or vim.env.PATH (os.getenv :PATH)))
    (local PATH (if path
                    (.. fmt (. (require :config.path) :sep) path)
                    fmt))
    (set opts.cmd_env {: PATH}))
  (lspconfig.ocamlls.setup opts)
  lspconfig.ocamlls)

(fn get-ocamlformat [cb]
  (if (exepath :ocamlformat-rpc)
      (cb)
      (installer.get :ocamlformat
                     (fn [err package]
                       (cb (when (not err)
                             (-?> (package:get_install_path)
                                  (path-join :bin))))))))

(fn [cb]
  (var ocaml-lsp nil)
  (var ocamlformat-path nil)

  (fn conf []
    (when (and ocaml-lsp ocamlformat-path)
      (cb (config (. ocaml-lsp 1) (. ocamlformat-path 1)))))

  (bin-or-install [:ocamllsp :ocaml-lsp :ocaml-language-server] :ocaml-lsp
                  :ocamllsp (fn [bin]
                             (set ocaml-lsp [bin])
                             (conf)))
  (get-ocamlformat (fn [path]
                     (set ocamlformat-path [path])
                     (conf))))

(fn on_attach [_ buffer]
  (local opts {: buffer :silent true :noremap true :nowait true})
  (local crates (require :crates))

  (fn km [k f desc]
    (vim.keymap.set :n (.. :<leader>c k) (. crates f)
                    {: buffer :silent true :noremap true :nowait true : desc}))

  (km :v :show_versions_popup "Show crate versions")
  (km :f :show_features_popup "Show crate features")
  (km :d :show_dependencies_popup "Show crate dependencies"))

{:lazy true
 :event "BufRead Cargo.toml"
 :deps [:plenary :cmp]
 :main :crates
 :opts {:completion {:cmp {:enabled true}}
        :null_ls {:enabled false}
        :lsp {:enabled true :actions true :completion false : on_attach}}}

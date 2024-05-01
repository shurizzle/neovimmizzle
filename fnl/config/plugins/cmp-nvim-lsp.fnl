(fn config []
  (local lsputil (require :lspconfig.util))
  (->> (fn [cfg]
         (->> ((. (require :cmp_nvim_lsp) :default_capabilities))
              (vim.tbl_deep_extend :force (or cfg.capabilities []))
              (tset cfg :capabilities)))
       (lsputil.add_hook_before lsputil.on_setup)
       (tset lsputil :on_setup)))

{:lazy true :deps [:neovim/nvim-lspconfig] : config}

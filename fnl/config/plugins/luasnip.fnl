(fn config []
  ((. (require :luasnip) :config :set_config) {:history true
                                               :enable_autosnippets false})
  ((. (require :luasnip.loaders.from_vscode) :lazy_load)))

{:lazy true
 :build (let [p (require :config.platform)]
          (.. (if (and p.is.bsd (not p.is.macos)) :gmake :make)
              " install_jsregexp"))
 :deps :rafamadriz/friendly-snippets
 : config}

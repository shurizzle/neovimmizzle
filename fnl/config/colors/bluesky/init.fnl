(let [unpack (or table.unpack _G.unpack)
      {: merge! : compile} (require :config.colors.blush)
      gens (icollect [_ name (ipairs [:gitsigns
                                      :indent-blankline
                                      :tree
                                      :barbar
                                      :telescope
                                      :lsp
                                      :treesitter
                                      :illuminate
                                      :breadcrumbs
                                      :prolog
                                      :notify])]
             (require (.. :config.colors.bluesky.support. name)))
      _ (table.insert gens 1 (require :config.colors.bluesky.base))
      cps (require :config.colors.bluesky.palette)]
  (fn gen* [cp]
    (compile (merge! (unpack (icollect [_ gen (ipairs gens)] (gen cp))))))

  {:dark (gen* cps.dark) :light (gen* cps.light)})


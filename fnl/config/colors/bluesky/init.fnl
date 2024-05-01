(let [unpack (or table.unpack _G.unpack)
      {: merge : compile} (require :config.colors.blush)
      supports [:gitsigns
                :indent-blankline
                :tree
                :barbar
                :telescope
                :lsp
                :treesitter
                :illuminate
                :breadcrumbs
                :prolog]]
  (compile (merge (pick-values 1 (require :config.colors.bluesky.base))
                  (unpack (icollect [_ name (ipairs supports)]
                            (pick-values 1
                                         (require (.. :config.colors.bluesky.support.
                                                      name))))))))

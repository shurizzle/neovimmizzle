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
                :prolog
                :notify]
      cp (require :config.colors.bluesky.palette)]
  (compile (merge ((require :config.colors.bluesky.base) cp)
                  (unpack (icollect [_ name (ipairs supports)]
                            ((require (.. :config.colors.bluesky.support. name)) cp))))))


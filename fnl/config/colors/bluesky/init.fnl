(let [{: merge} (require :lush)
      supports [:gitsigns :indent-blankline :tree :barbar :telescope :lsp 
                :treesitter :illuminate :breadcrumbs :prolog]]
  (var theme
    (icollect [_ name (ipairs supports)] (require (.. :config.colors.bluesky.support. name))))
  (table.insert theme 1 (require :config.colors.bluesky.base))
  (merge theme))

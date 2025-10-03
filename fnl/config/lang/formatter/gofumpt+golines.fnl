(local {: bin-or-install : conform} (require :config.lang.util))
(fn [cb]
  (var cnt 2)
  (local bins [])

  (fn done []
    (dec! cnt)
    (when (= 0 cnt)
      (tset (require :conform) :formatters :golines
            {:command (if bins.golines bins.golines :golines)
             :args (if bins.gofumpt [:--base-formatter bins.gofumpt] nil)})
      (cb :golines)))

  (bin-or-install :gofumpt (fn [bin]
                             (set bins.gofumpt bin)
                             (done)))
  (bin-or-install :golines (fn [bin]
                             (set bins.golines bin)
                             (done))))

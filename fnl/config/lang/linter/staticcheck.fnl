(local {: bin-or-install : lint} (require :config.lang.util))

(fn [cb]
  (let [lint (require :lint)]
    (set lint.linters.staticcheck.append_fname false))
  (bin-or-install :staticcheck (lint :staticcheck cb)))

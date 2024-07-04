(local {: bin-or-install : lint} (require :config.lang.util))

(fn [cb]
  (bin-or-install :staticcheck (lint :staticcheck cb)))

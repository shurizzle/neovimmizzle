(local {: bin-or-install : lint} (require :config.lang.util))

(fn [cb]
  (bin-or-install :phpcs (lint :phpcs cb)))

(local {: bin-or-install : lint} (require :config.lang.util))

(fn [cb]
  (bin-or-install :ktlint (lint :ktlint [:--reporter=json :--stdin] cb)))

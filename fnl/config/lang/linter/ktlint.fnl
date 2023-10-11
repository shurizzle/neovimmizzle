(autoload [{: bin-or-install : lint} :config.lang.util])

(fn [cb]
  (bin-or-install :ktlint (lint :ktlint cb)))

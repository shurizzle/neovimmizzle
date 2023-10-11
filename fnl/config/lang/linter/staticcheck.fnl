(autoload [{: bin-or-install : lint} :config.lang.util])

(fn [cb]
  (bin-or-install :staticcheck (lint :staticcheck cb)))

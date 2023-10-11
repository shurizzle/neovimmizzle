(autoload [{: bin-or-install : lint} :config.lang.util])

(fn [cb]
  (bin-or-install :shellcheck (lint :shellcheck cb)))

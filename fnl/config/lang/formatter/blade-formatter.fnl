(local {: bin-or-install : conform} (require :config.lang.util))

(fn [cb]
  (bin-or-install :blade-formatter (conform :blade-formatter cb)))

(autoload [{: bin-or-install : conform} :config.lang.util])

(fn [cb]
  (bin-or-install :blade-formatter (conform :blade-formatter cb)))

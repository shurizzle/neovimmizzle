(autoload [{: bin-or-install : conform} :config.lang.util])
(fn [cb] (bin-or-install :black (conform :black cb)))

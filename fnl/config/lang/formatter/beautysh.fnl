(autoload [{: bin-or-install : conform} :config.lang.util])
(fn [cb] (bin-or-install :beautysh (conform :beautysh cb)))

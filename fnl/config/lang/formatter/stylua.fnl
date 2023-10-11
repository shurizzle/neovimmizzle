(autoload [{: bin-or-install : conform} :config.lang.util])
(fn [cb] (bin-or-install :stylua (conform :stylua cb)))

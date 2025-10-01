(local {: bin-or-install : conform} (require :config.lang.util))
(fn [cb] (bin-or-install :gofumpt (conform :gofumpt cb)))

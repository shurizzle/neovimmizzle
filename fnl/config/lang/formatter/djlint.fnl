(local {: bin-or-install : conform} (require :config.lang.util))

(fn [cb]
  (bin-or-install :djlint (conform :djlint cb)))


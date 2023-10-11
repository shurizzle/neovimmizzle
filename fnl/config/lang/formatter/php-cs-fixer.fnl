(autoload [{: bin-or-install : conform} :config.lang.util])

(local rules "@PSR12,ordered_imports,no_unused_imports")

(fn [cb]
  (bin-or-install :php-cs-fixer
                  (conform :php_cs_fixer
                           [:--no-interaction :--quiet :fix
                            (.. :--rules= rules) :$FILENAME]
                           cb)))

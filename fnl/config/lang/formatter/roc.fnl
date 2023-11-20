(autoload [{: conform} :config.lang.util])

(fn register [bin]
  (local conform (require :conform))
  (set conform.formatters.roc
       {:meta {:url "https://roc-lang.org/"
               :description "A fast, friendly, functional language."}
        :command (or bin :roc)
        :args [:format :--stdin :--stdout]}))

(fn [cb]
  (register)
  (cb :roc))

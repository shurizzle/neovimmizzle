(autoload [{: bin-or-install : conform} :config.lang.util])

(fn register []
  (local conform (require :conform))
  (set conform.formatters.blade-formatter
       {:meta    {:url "https://github.com/shufo/blade-formatter"
                  :description "An opinionated blade template formatter for Laravel that respects readability."}
        :command :blade-formatter
        :args    [:--stdin]
        :stdin   true
        :cwd     ((. (require :conform.util) :root_file)
                  [:composer.json :composer.lock])}))

(fn [cb]
  (register)
  (bin-or-install :blade-formatter (conform :blade-formatter cb)))

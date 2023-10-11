(autoload [{: bin-or-install : conform} :config.lang.util])

(fn register []
  (local conform (require :conform))
  (set conform.formatters.blade-formatter
       {:meta    {:url "https://github.com/lovesegfault/beautysh"
                  :description "A Bash beautifier for the masses."}
        :command :blade-formatter
        :args    [:--stdin]
        :stdin   true
        :cwd     ((. (require :conform.util) :root_file)
                  [:composer.json :composer.lock])}))

(fn [cb]
  (register)
  (bin-or-install :blade-formatter (conform :blade-formatter cb)))

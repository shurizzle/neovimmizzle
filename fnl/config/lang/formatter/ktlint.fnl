(autoload [{: bin-or-install : conform} :config.lang.util])

(fn register []
  (local conform (require :conform))
  (set conform.formatters.ktlint
       {:meta    {:url "https://ktlint.github.io/"
                  :description "An anti-bikeshedding Kotlin linter with built-in formatter."}
        :command :ktlint
        :args    [:--format :--stdin "**/*.kt" "**/*.kts"]
        :stdin   true}))

(fn [cb]
  (register)
  (bin-or-install :ktlint (conform :ktlint cb)))

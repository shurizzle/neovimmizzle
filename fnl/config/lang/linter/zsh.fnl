(fn register []
  (local lint (require :lint))
  (local pattern "(.+):(%d+): (.+)")
  (local groups [:file :lnum :message])
  (set lint.linters.zsh
       {:meta {:url "https://www.zsh.org/"
               :description "Uses zsh's own -n option to evaluate, but not execute, zsh scripts. Effectively, this acts somewhat like a linter, although it only really checks for serious errors - and will likely only show the first error."}
        :cmd :zsh
        :args [:-n]
        :stdin false
        :stream :stderr
        :ignore_exitcode true
        :parser ((. (require :lint.parser) :from_pattern) pattern groups nil
                                                          {:severity vim.diagnostic.severity.ERROR
                                                           :source :zsh})}))

(fn [cb]
  (register)
  (cb :zsh))

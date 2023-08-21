(autoload [{:pcall f-pcall : future : and-then} :config.future
           {: notify-progress} :config.lang.util
           mr :mason-registry])

(fn do-install [p version]
  (fn start [notify]
    (notify
      (if version
          (.. p.name ": upgrading to " version)
          (.. p.name ": installing"))
      vim.log.levels.INFO
      {:title :Mason})
    (future (fn [resolve reject]
              (p:once :install:success (fn [] (resolve p)))
              (p:once :install:failed reject))))
  (fn finish [notify ok]
    (if ok
        (notify
          (.. p.name ": successfully " (if version :upgraded :installed))
          vim.log.levels.INFO
          {:title :Mason})
        (notify
          (.. p.name ": failed to " (if version :upgrade :install))
          vim.log.levels.ERROR
          {:title :Mason})))

  (let [f (notify-progress start finish)]
    (p:install {: version})
    f))

(fn install-or-upgrade [what]
  (f-pcall
    (fn []
      (let [p (mr.get_package what)]
        (if (p:is_installed)
            (future
              (fn [resolve reject]
                (p:check_new_version
                  (fn [ok version]
                    (if
                      ok (and-then (do-install p version.latest_version)
                                   resolve reject)
                      (and (string? version)
                           (string.match version "is not outdated"))
                        (resolve p)
                      (do
                        (vim.notify (.. what ": update error")
                                    vim.log.levels.INFO
                                    {:title :Mason})
                        (reject version)))))))
            (do-install p nil))))))

(let [{: generating-map} (require :config.generating_map)]
  (generating-map
    (fn [name]
      (vim.validate {:name [name :s]})
      (install-or-upgrade name))))

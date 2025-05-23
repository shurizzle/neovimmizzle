(local *installers* [])

(fn default-timeout []
  (let [(ok res) (pcall (fn []
                          ((. ((. (require :notify) :_config)) :default_timeout))))]
    (or (and ok res) 5000)))

(fn notify* [...]
  (let [(ok notify) (pcall #(require :notify))]
    ((if (and ok notify.notify) notify.notify vim.notify) ...)))

(fn do-install [p version cb]
  (local win (vim.api.nvim_get_current_win))
  (local id
         (notify* (if version
                      (.. p.name ": upgrading to " version)
                      (.. p.name ": installing"))
                  vim.log.levels.INFO {:title :Mason :timeout false}))

  (fn finish [err]
    (fn notify []
      (if err
          (notify* (.. p.name ": failed to " (if version :upgrade :install))
                   vim.log.levels.ERROR
                   {:title :Mason :timeout (default-timeout) :replace id})
          (notify* (.. p.name ": successfully "
                       (if version :upgraded :installed))
                   vim.log.levels.INFO
                   {:title :Mason :timeout (default-timeout) :replace id})))

    (or (pick-values 1 (pcall vim.api.nvim_win_call win notify)) (pcall notify))
    (if err
        (cb err)
        (cb nil p)))

  (p:once "install:success" (fn [] (vim.schedule finish)))
  (p:once "install:failed"
          (fn [& args]
            (vim.schedule #(finish (unpack args)))))
  (p:install {: version}))

(fn mason-is2? []
  (= 2 (. (require :mason.version) :MAJOR_VERSION)))

(fn install-or-upgrade [what cb]
  (fn try-upgrade [p]
    (if (mason-is2?)
        (let [current (p:get_installed_version)
              (ok latest) (pcall #(p:get_latest_version))]
          (if ok
              (if current
                  (if (= latest current)
                      (cb nil p)
                      (do-install p latest cb))
                  (do-install p latest cb))
              (do
                (notify* (if (string? latest) latest (vim.inspect latest))
                         vim.log.levels.ERROR {:title :Mason})
                (cb latest))))
        (p:check_new_version (fn [ok version]
                               (if ok
                                   (do-install p version.latest_version cb)
                                   (and (string? version)
                                        (string.match version "is not outdated"))
                                   (cb nil p)
                                   (do
                                     (notify* (if (string? version) version
                                                  (vim.inspect version))
                                              vim.log.levels.ERROR
                                              {:title :Mason})
                                     (cb version)))))))

  (if (mason-is2?)
      (let [mr (require :mason-registry)
            (ok p) (pcall #(mr.get_package what))]
        (if ok
            (if (p:is_installed)
                (try-upgrade p)
                (do-install p nil cb))
            (let [err (.. what " not found")]
              (notify* (.. "DIOC " err) vim.log.levels.ERROR {:title :Mason})
              (cb err))))
      (do
        (fn try-install [p]
          (if (not p)
              (let [err (.. what " not found")]
                (notify* err vim.log.levels.ERROR {:title :Mason})
                (cb err))
              (if (p:is_installed)
                  (try-upgrade p)
                  (do-install p nil cb))))
        (let [mr (require :mason-registry)
              p (mr.get_package what)]
          (local (ok err) (pcall try-install p))
          (when (not ok)
            (notify* (if (string? err) err (vim.inspect err))
                     vim.log.levels.ERROR {:title :Mason})
            (cb err))))))

(fn get* [what cb]
  (fn inner []
    (let [installer (. *installers* what)]
      (if installer
          (if installer.result
              (cb (unpack installer.result))
              (table.insert installer.callbacks cb))
          (let [state {:callbacks [cb]}]
            (tset *installers* what state)
            (install-or-upgrade what
                                (fn [err res]
                                  (set state.result [err res])
                                  (local cbs state.callbacks)
                                  (set state.callbacks nil)
                                  (each [_ cb (ipairs cbs)]
                                    (vim.schedule #(cb (unpack state.result))))))))))

  (if (or (vim.in_fast_event) (= 1 (vim.fn.has :vim_starting)))
      (vim.schedule inner)
      (inner))
  nil)

(fn get [what ?cb]
  (vim.validate :what what :string)
  (vim.validate :?cb ?cb :function true)
  (if ?cb
      (get* what ?cb)
      (let [co (assert (coroutine.running) "not in coroutine")]
        (get* what (fn [...] (coroutine.resume co ...)))
        (coroutine.yield))))

(fn map* [what mapper cb]
  (get* what (fn [err p]
               (if (not err)
                   (let [(ok res) (pcall mapper p)]
                     (if ok
                         (cb nil res)
                         (cb res)))
                   (cb err)))))

(fn map [what mapper]
  (vim.validate :what what :string)
  (vim.validate :mapper mapper :function)
  (fn [?cb]
    (vim.validate :?cb ?cb :function true)
    (if ?cb
        (map* what mapper ?cb)
        (let [co (assert (coroutine.running) "not in coroutine")]
          (map* what mapper (fn [...] (coroutine.resume co ...)))
          (coroutine.yield)))))

(setmetatable {} {:__index (fn [_ name]
                             (if (= :get name) get
                                 (= :map name) map
                                 (get name)))
                  :__newindex (fn [])})

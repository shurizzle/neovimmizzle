(autoload [{:bin_prefix mason-bin-prefix} :mason-core.path
           {:join path-join} :config.path
           {: access : scandir : stat} :config.fs
           installer :config.lang.installer
           {: split : filter : filter-map} :config.iter
           {: is} :config.platform])

(fn callback-memoize [generator]
  (local state {:callbacks []})
  (local (ok err) (pcall generator
                         (fn [err res]
                           (set state.result [err res])
                           (local cbs state.callbacks)
                           (set state.callbacks nil)
                           (each [_ cb (ipairs cbs)]
                             (vim.schedule #(cb (unpack state.result)))))))
  (when (not ok)
    (set state.result [err nil])
    (set state.callbacks nil))
  (fn [cb]
    (if state.result
        (cb (unpack state.result))
        (table.insert state.callbacks cb))
    nil))

(fn executable? [path]
  (fn file? [path]
    (match (stat path)
      (nil _ :ENOENT) false
      (nil err _) (error err)
      md (= md.type :file)))

  (fn exe? [path]
    (match (access path :X)
      (nil _ :ENOENT) false
      (nil err _) (error err)
      res res))

  (and (file? path) (exe? path)))

;; TODO: test
(fn bin-in-dir-win [dir bin]
  (vim.validate {:dir [dir :s]
                 :bin [bin :s]})

  (local exts (icollect [e (filter-map
                             #(when (> (length $1) 0) (string.upper $1))
                             (split (os.getenv :PATHEXT) ";+"))]
                e))

  (fn strip-suffix [str suff]
    (when (and (> (length str) (length suff))
               (= (str:sub (- (length suff))) suff))
      (str:sub 1 (- (+ 1 (length suff))))))

  (fn file-matcher [bin* exts]
    (local bin (string.upper bin*))

    (fn match-file [file]
      (let [name (some (partial strip-suffix file) exts)]
        (= bin name)))

    (local match-name (if (some (partial strip-suffix bin) exts)
                          (fn [file]
                            (or (= bin file) (match-file file)))
                          (fn [file]
                            (match-file file))))

    (fn [path file*]
      (let [file (string.upper file*)]
        (when (match-name file)
          (let [full-path (path-join path file*)]
            (when (executable? full-path)
              full-path))))))

  (some (partial (file-matcher bin exts) dir) (assert (scandir dir))))

(local bin-in-dir (if is.win
                      bin-in-dir-win
                      (fn [dir bin]
                        (let [full-path (path-join dir bin)]
                          (when (executable? full-path)
                            full-path)))))

(fn mason-bin [file]
  (vim.validate {:file [file :s true]})
  (if file
      (bin-in-dir (path-join (mason-bin-prefix) file))
      (mason-bin-prefix)))

(fn mason-get [package-name ?bin-name cb]
  (local (?bin-name* cb*) (if (not cb)
                              (values nil ?bin-name)
                              (values ?bin-name cb)))
  (vim.validate {:package-name [package-name :s]
                 :?bin-name    [?bin-name*   :s true]
                 :cb           [cb*          :f]})
  (local bin-name (or ?bin-name* package-name))
  (installer.get
    package-name
    (fn [err]
      (cb* (when (not err) (mason-bin bin-name))))))

(fn bin-or-install [bins ?package-name ?bin-name cb]
  (var package-name ?package-name)
  (var bin-name ?bin-name)
  (var cb* cb)
  (when (not cb)
    (if (not bin-name)
        (do
          (set cb* package-name)
          (set package-name nil))
        (do
          (set cb* bin-name)
          (set bin-name nil))))
  (when (not package-name)
    (set package-name bins))
  (when (not bin-name)
    (set bin-name package-name))
  (local bins* (if (not (table? bins)) [bins] bins))

  (vim.validate {:bins          [bins*        :t]
                 :?package-name [package-name :s]
                 :?bin-name     [bin-name     :s]
                 :cb            [cb*          :f]})
  (local bin (some exepath bins*))
  (if bin
      (cb* bin)
      (mason-get package-name bin-name cb*)))

(fn conform [name ?opts cb]
  (var ?opts* nil)
  (var cb* nil)
  (if (not cb)
      (set cb* ?opts)
      (do
        (set ?opts* ?opts)
        (set cb* cb)))
  (vim.validate {:name  [name   :s]
                 :?opts [?opts* [:t :s] true]
                 :cb    [cb*    :f]})
  (when (string? ?opts*)
    (set ?opts* [?opts*]))
  (fn [bin]
    (local fmt (let [fmt (. (require :conform) :formatters name)]
                 (if fmt
                     fmt
                     (let [(ok fmt) (pcall require (.. :conform.formatters.
                                                       name))]
                       (when ok fmt)))))

    (when (and bin fmt)
      (tset fmt :command bin))
    (when (and ?opts* fmt)
      (tset fmt :args ?opts*))
    (cb* name)))

(fn lint [name ?opts cb]
  (var ?opts* nil)
  (var cb* nil)
  (if (not cb)
      (set cb* ?opts)
      (do
        (set ?opts* ?opts)
        (set cb* cb)))
  (vim.validate {:name  [name   :s]
                 :?opts [?opts* [:t :s] true]
                 :cb    [cb*    :f]})
  (when (string? ?opts*)
    (set ?opts* [?opts*]))
  (fn [bin]
    (local lint (let [lint (. (require :lint) :linters name)]
                  (if lint
                      lint
                      (let [(ok lint) (pcall require (.. :lint.linters. name))]
                        (when ok lint)))))

    (when (and bin lint)
      (tset lint :cmd bin))
    (when (and ?opts* lint)
      (tset lint :args ?opts*))
    (cb* name)))

{: callback-memoize
 : mason-bin
 : mason-get
 : bin-in-dir
 : bin-or-install
 : conform
 : lint}

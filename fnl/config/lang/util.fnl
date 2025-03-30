(local {:join path-join} (require :config.path))
(local {: access : scandir : stat} (require :config.fs))
(local {: split : filter-map} (require :config.iter))
(local {: is} (require :config.platform))

(fn callback-memoize [generator]
  (local state {:callbacks []})
  (local (ok err)
         (pcall generator
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
    (case (stat path)
      (nil _ :ENOENT) false
      (nil err _) (error err)
      md (= md.type :file)))

  (fn exe? [path]
    (case (access path :X)
      (nil _ :ENOENT) false
      (nil err _) (error err)
      res res))

  (and (file? path) (exe? path)))

;; TODO: test
(fn bin-in-dir-win [dir bin]
  (vim.validate :dir dir :string)
  (vim.validate :bin bin :string)
  (local exts (icollect [e (filter-map #(when (> (length $1) 0)
                                          (string.upper $1))
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

(fn mason-is2? []
  (= 2 (. (require :mason.version) :MAJOR_VERSION)))

(fn mason-bin-prefix []
  (if (mason-is2?)
      (vim.fn.expand :$MASON/bin)
      ((. (require :mason-core.path) :bin_prefix))))

(fn mason-get-install-path [p]
  (if (mason-is2?)
      (vim.fn.expand (.. :$MASON/packages/ p.name))
      (p:get_install_path)))

(fn mason-bin [file]
  (vim.validate :file file :string true)
  (if file
      (bin-in-dir (path-join (mason-bin-prefix) file))
      (mason-bin-prefix)))

(fn mason-get [package-name ?bin-name cb]
  (local (?bin-name* cb*) (if (not cb)
                              (values nil ?bin-name)
                              (values ?bin-name cb)))
  (vim.validate :package-name package-name :string)
  (vim.validate :?bin-name ?bin-name* :string true)
  (vim.validate :cb cb* :function)
  (local bin-name (or ?bin-name* package-name))
  (let [installer (require :config.lang.installer)]
    (installer.get package-name
                   (fn [err]
                     (cb* (when (not err) (mason-bin bin-name)))))))

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
  (vim.validate :bins bins* :table)
  (vim.validate :?package-name package-name :string)
  (vim.validate :?bin-name bin-name :string)
  (vim.validate :cb cb* :function)
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
  (vim.validate :name name :string)
  (vim.validate :?opts ?opts* [:table :string] true)
  (vim.validate :cb cb* :function)
  (when (string? ?opts*)
    (set ?opts* [?opts*]))
  (fn [bin]
    (local fmt (let [fmt (. (require :conform) :formatters name)]
                 (if fmt
                     fmt
                     (let [(ok fmt) (pcall require
                                           (.. :conform.formatters. name))]
                       (when ok fmt)))))
    (when (and bin fmt)
      (set fmt.command bin))
    (when (and ?opts* fmt)
      (set fmt.args ?opts*))
    (cb* name)))

(fn lint [name ?opts cb]
  (var ?opts* nil)
  (var cb* nil)
  (if (not cb)
      (set cb* ?opts)
      (do
        (set ?opts* ?opts)
        (set cb* cb)))
  (vim.validate :name name :string)
  (vim.validate :?opts ?opts* [:table :string] true)
  (vim.validate :cb cb* :function)
  (when (string? ?opts*)
    (set ?opts* [?opts*]))
  (fn [bin]
    (local lint (let [lint (. (require :lint) :linters name)]
                  (if lint
                      lint
                      (let [(ok lint) (pcall require (.. :lint.linters. name))]
                        (when ok lint)))))
    (when (and bin lint)
      (set lint.cmd bin))
    (when (and ?opts* lint)
      (set lint.args ?opts*))
    (cb* name)))

{: callback-memoize
 : mason-bin
 : mason-get
 : bin-in-dir
 : bin-or-install
 : conform
 : lint
 : mason-get-install-path}


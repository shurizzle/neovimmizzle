(macro filename [x]
  (. x :filename))

(local {: is} (require :config.platform))
(local {: access : scandir : stat} (require :config.fs))
(local {: split : filter-map} (require :config.iter))
(local dir-sep (if is.win "\\" "/"))

(local path {: dir-sep
             :sep (if is.win ";" ":")
             :join (fn [...] (table.concat [...] dir-sep))
             :real vim.loop.fs_realpath
             :canonical (lambda [path] (vim.fn.fnamemodify path ":p"))
             :dirname (lambda [path] (vim.fn.fnamemodify path ":h"))
             :file (lambda [path] (vim.fn.fnamemodify path ":t"))
             :ext (lambda [path] (vim.fn.fnamemodify path ":e"))})

(set path.extension path.ext)
(set path.init-dir (-> (filename path)
                       (path.dirname)
                       (path.join ".." "..")
                       (path.real)))

(fn path.dirs []
  (vim.tbl_map (fn [x]
                 (x:gsub (.. (vim.pesc path.dir-sep) "+$") ""))
               (vim.split vim.env.PATH (vim.pesc path.sep) {:trimempty true})))

(lambda set-path [paths]
  (vim.validate :paths paths :table)
  (set vim.env.PATH (table.concat paths path.sep)))

(lambda path.prepend [dir]
  (let [dirs (vim.tbl_filter (fn [e] (not= e dir)) (path.dirs))]
    (table.insert dirs 1 dir)
    (set-path dirs)))

(lambda path.append [dir]
  (let [dirs (vim.tbl_filter (fn [e] (not= e dir)) (path.dirs))]
    (table.insert dirs dir)
    (set-path dirs)))

(fn path.executable? [p]
  (fn file? [p]
    (case (stat p)
      (nil _ :ENOENT) false
      (nil err _) (error err)
      md (= md.type :file)))

  (fn exe? [p]
    (case (access p :X)
      (nil _ :ENOENT) false
      (nil err _) (error err)
      res res))

  (and (file? p) (exe? p)))

(fn path.dir? [p]
  (case (stat p)
    (nil :ENOENT) false
    (nil err) (error err)
    md (= md.type :directory)))

(fn unix-bin-in-dir [dir bin]
  (let [full-path (path.join dir bin)]
    (when (path.executable? full-path)
      full-path)))

(fn win-bin-in-dir [dir bin]
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
    (fn [dir file*]
      (let [file (string.upper file*)]
        (when (match-name file)
          (let [full-path (path.join dir file*)]
            (when (path.executable? full-path)
              full-path))))))

  (let [matcher (file-matcher bin exts)]
    (local dirfd (vim.uv.fs_scandir dir))

    (fn next* []
      (when dirfd
        (match (vim.uv.fs_scandir_next dirfd)
          (nil err _) (if err (error err) nil)
          (where entry (not= nil entry)) entry)))

    (var result nil)
    ;; (each [f (scandir dir) &until result]
    (each [f next* &until result]
      (when (matcher dir f)
        (set result (path.join dir f))))
    result))

(set path.bin-in-dir (if is.win win-bin-in-dir unix-bin-in-dir))

(fn path.which [bin]
  (vim.validate :bin bin :string)
  (var result nil)
  (each [_ dir (ipairs (path.dirs)) &until result]
    (when (path.dir? dir)
      (let [p (path.bin-in-dir dir bin)]
        (when p (set result p)))))
  result)

(readonly-table path)

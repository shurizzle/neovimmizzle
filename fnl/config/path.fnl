(macro filename [x]
  (. x :filename))

(local platform (require :config.platform))
(local dir-sep (if platform.is.win :\ :/))

(var path {:dir-sep dir-sep
           :dir_sep dir-sep
           :sep (if platform.is.win ";" ::)
           :join (fn [...] (table.concat [...] dir-sep))
           :real vim.loop.fs_realpath
           :canonical (lambda [path] (vim.fn.fnamemodify path ::p))
           :file (lambda [path] (vim.fn.fnamemodify path ::h))
           :ext (lambda [path] (vim.fn.fnamemodify path ::e))
     })
(tset path :extension path.ext)
(tset path :dirname path.file)
(tset path :init_dir (-> (filename path)
                         (path.dirname)
                         (path.join :.. :..)
                         (path.real)))
(tset path :init-dir path.init_dir)

(fn path.dirs []
  (vim.tbl_map (fn [x] (x:gsub (.. (vim.pesc path.dir-sep) :+$) ""))
               (vim.split vim.env.PATH (vim.pesc path.sep) {:trimempty true})))

(lambda set-path [paths]
  (vim.validate {:paths [paths :t]})
  (set vim.env.PATH (table.concat paths path.sep)))

(lambda path.prepend [dir]
  (let [dirs (vim.tbl_filter (fn [e] (not= e dir)) (path.dirs))]
    (table.insert dirs 1 dir)
    (set-path dirs)))

(lambda path.append [dir]
  (let [dirs (vim.tbl_filter (fn [e] (not= e dir)) (path.dirs))]
    (table.insert dirs dir)
    (set-path dirs)))

(lambda path.which [bin]
  (vim.validate {:bin [bin :s]})
  (each [_ dir (ipairs (path.dirs))]
    (let [p (path.join dir bin)]
      (if (executable p) (lua "return p")))))

(readonly-table path)

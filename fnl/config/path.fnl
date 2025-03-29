(macro filename [x]
  (. x :filename))

(local {: is} (require :config.platform))
(local dir-sep (if is.win "\\" "/"))

(var path {: dir-sep
           :sep (if is.win ";" ":")
           :join (fn [...] (table.concat [...] dir-sep))
           :real vim.loop.fs_realpath
           :canonical (lambda [path] (vim.fn.fnamemodify path ":p"))
           :dirname (lambda [path] (vim.fn.fnamemodify path ":h"))
           :file (lambda [path] (vim.fn.fnamemodify path ":t"))
           :ext (lambda [path] (vim.fn.fnamemodify path ":e"))})

(tset path :extension path.ext)
(tset path :init-dir (-> (filename path)
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

(lambda path.which [bin]
  (vim.validate :bin bin :string)
  (each [_ dir (ipairs (path.dirs))]
    (let [p (path.join dir bin)]
      (if (executable p) (lua "return p")))))

(readonly-table path)

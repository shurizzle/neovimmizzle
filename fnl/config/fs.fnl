(autoload [uv :luv])

(fn map-scandir [fs ...]
  (if fs
      (fn []
        (match (uv.fs_scandir_next fs)
          (nil err _) (if err (error err) nil)
          (where entry (not= nil entry)) entry))
      (values fs ...)))

(fn scandir [path ?callback]
  (vim.validate {:path [path :s] :?callback [?callback :f true]})
  (if ?callback
      (uv.fs_scandir path
                     (fn [err fs]
                       (if err
                           (?callback err fs)
                           (?callback err (map-scandir fs)))))
      (let [co (coroutine.running)]
        (if co
            (do
              (uv.fs_scandir path (fn [...] (coroutine.resume co ...)))
              (let [(err fs) (coroutine.yield)]
                (if err
                    (values nil err)
                    (map-scandir fs))))
            (map-scandir (uv.fs_scandir path))))))

(fn stat [path ?callback]
  (vim.validate {:path [path :s] :?callback [?callback :f true]})
  (if ?callback
      (uv.fs_stat path ?callback)
      (let [co (coroutine.running)]
        (if co
            (do
              (uv.fs_stat path (partial coroutine.resume co))
              (let [(err md) (coroutine.yield)]
                (if err
                    (values nil err)
                    md)))
            (uv.fs_stat path)))))

(fn access [path mode ?cb]
  (vim.validate {:path [path :s] :mode [mode :s] :?cb [?cb :f true]})
  (if ?cb
      (uv.fs_access path mode ?cb)
      (let [co (coroutine.running)]
        (if co
            (do
              (uv.fs_stat path (partial coroutine.resume co))
              (let [(err res) (coroutine.yield)]
                (if err
                    (values nil err)
                    res)))
            (uv.fs_access path mode)))))

{: scandir : stat : access}

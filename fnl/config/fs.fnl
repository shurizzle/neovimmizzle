(local uv (require :luv))

(fn map-scandir [fs ...]
  (if fs
      (fn []
        (match (uv.fs_scandir_next fs)
          (nil err _) (if err (error err) nil)
          (where entry (not= nil entry)) entry))
      (if (empty? [...])
          #nil
          (error ...))))

(fn scandir [path ?callback]
  (vim.validate :path path :string)
  (vim.validate :?callback ?callback :function true)
  (if ?callback
      (uv.fs_scandir path
                     (fn [err fs]
                       (if err
                           (?callback err fs)
                           (?callback err (map-scandir fs)))))
      (let [co (coroutine.running)]
        (if co
            (do
              (uv.fs_scandir path (partial coroutine.resume co))
              (let [(err fs) (coroutine.yield)]
                (if err
                    (error err)
                    (map-scandir fs))))
            (map-scandir (uv.fs_scandir path))))))

(fn map-err [err]
  (if (string? err)
      (or (string.match err "^(.-):") err)
      err))

(fn stat [path ?callback]
  (vim.validate :path path :string)
  (vim.validate :?callback ?callback :function true)
  (if ?callback
      (uv.fs_stat path ?callback)
      (let [co (coroutine.running)]
        (if co
            (do
              (uv.fs_stat path (partial coroutine.resume co))
              (let [(err md) (coroutine.yield)]
                (if err
                    (values nil (map-err err))
                    md)))
            (let [(ok res) (pcall #(uv.fs_stat path))]
              (if ok
                  res
                  (values nil (map-err))))))))

(fn access [path mode ?cb]
  (vim.validate :path path :string)
  (vim.validate :mode mode :string)
  (vim.validate :?cb ?cb :function true)
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

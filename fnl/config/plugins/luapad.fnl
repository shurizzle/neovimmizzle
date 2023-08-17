(fn config []
  (local path (require :config.path))
  (fn on_init []
    (let [file (-?> (vim.api.nvim_buf_get_name 0) (vim.loop.fs_realpath))
          dir (-?> file path.dirname)]
      (if file
          (vim.loop.fs_copyfile
            (path.join path.init-dir :.luarc.json)
            (path.join dir :.luarc.json)
            {:ficlone true :ficlone_force true}))))
  ((. (require :luapad) :setup) {: on_init}))

{:lazy true
 :cmd [:Luapad :LuaRun :Lua]
 : config}

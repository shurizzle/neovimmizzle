(local path-sep (if (: (. (vim.loop.os_uname) :sysname) :match :Windows) :\ :/))

(fn path-join [...]
  (table.concat [...] path-sep))

(local realpath vim.loop.fs_realpath)

(fn dirname [path]
  (vim.validate {:path [path :s]})
  (vim.fn.fnamemodify path ":h"))

(local init-dir (-> (debug.getinfo 1 :S)
                    (. :source)
                    ((fn [s] [(: s :gsub "^@" "")]))
                    (. 1)
                    (dirname)
                    (realpath)))

(if (not (vim.tbl_contains (vim.opt.rtp:get) init-dir))
    (vim.opt.rtp:append init-dir))

(vim.cmd.helptags (path-join init-dir :doc))

(fn git-clone [url dir ?params ?callback]
  (vim.validate {:url [url :s]
                 :dir [dir :s]})
  (let [install-path (path-join (vim.fn.stdpath :data) :lazy dir)]
    (if (not (vim.loop.fs_stat install-path))
        (do
          (let [cmd [:git :clone]]
            (when (not= nil ?params)
              (each [_ value (ipairs ?params)]
                (table.insert cmd value)))
            (table.insert cmd url)
            (table.insert cmd install-path)

            (vim.fn.system cmd))

          (when (= vim.v.shell_error 0)
            (vim.cmd.helptags (path-join install-path :doc))
            (vim.opt.rtp:append install-path))
          (when (= :function (type ?callback))
            (?callback vim.v.shell_error install-path)))
        (do
          (vim.cmd.helptags (path-join install-path :doc))
          (vim.opt.rtp:append install-path)
          (when (= :function (type ?callback))
            (?callback 0 install-path))))))

(if (= (vim.fn.has "nvim-0.9.0") 0)
    (do
      (git-clone
        "https://github.com/lewis6991/impatient.nvim"
        :impatient.nvim
        [:--depth :1])
      (xpcall
        (fn [] (require :impatient))
        (fn [] (vim.api.nvim_echo [["Error while loading impatient" :ErrorMsg]] true []))))
    (vim.loader.enable))

(git-clone
  "https://github.com/folke/lazy.nvim.git"
  :lazy.nvim
  [:--filter=blob:none :--branch=stable])

(git-clone
  "https://github.com/rktjmp/hotpot.nvim.git"
  :hotpot.nvim
  [:--filter=blob:none :--single-branch])

(local hotpot (require :hotpot))
(require :hotpot.fennel)

(fn slurp [path]
  (match (io.open path "r")
    (nil _msg) nil
    f (let [content (f:read "*all")]
        (f:close)
        content)))

(fn additional-macros []
  (local f (require :hotpot.fennel))
  (local fc (require :fennel.compiler))
  (f.eval (slurp (path-join init-dir :fnl :config :init-macros.fnl))
          {:env :_COMPILER :scope fc.scopes.compiler}))

(let [fc (require :fennel.compiler)]
  (set fc.scopes.global.macros
       (vim.tbl_deep_extend :force fc.scopes.global.macros (additional-macros))))

(fn preprocessor [src {: path : macro?}]
  (local prefix (path-join init-dir :fnl :config :lang :_ ""))
  (if (and (not macro?) (-?> path (realpath) (vim.startswith prefix)))
    (..
      "(import-macros {: mkconfig} :config.lang.macros)\n"
      src)
    src))

(fn has-bit-operators []
  (fn version-has-bit-operators [[major minor]]
    (if
      (> major 5) true
      (< major 5) false
      (> minor 2) true
      false))

  (if
    (= :table (type _G.jit)) false
    (-?> (if _G._VERSION
             (icollect [_ n (ipairs [(_G._VERSION:match "Lua (%d+)%.(%d+)")])]
               (tonumber n))
             nil)
         (version-has-bit-operators))))
(local use-bit-lib (not (has-bit-operators)))

(hotpot.setup {:provide_require_fennel true
               :enable_hotpot_diagnostics true
               :compiler {:modules {:correlate true
                                    :useBitLib use-bit-lib}
                          :macros   {:env :_COMPILER
                                     :compiler-env _G
                                     :useBitLib use-bit-lib}
                          : preprocessor}})

;; HACK: placeholder
(let [fc (require :fennel.compiler)]
  (tset fc.scopes.global.includes :config.bootstrap "(function(...) end)"))

(fn watcher []
  (let [{: build} hotpot.api.make
        {: compile-file} hotpot.api.compile
        {: search} (require :hotpot.searcher)
        uv vim.loop
        init-file (path-join init-dir :init.fnl)
        fnl-lualine-theme (path-join init-dir :fnl :lualine :themes :bluesky.fnl)
        lua-lualine-theme (path-join init-dir :lua :lualine :themes :bluesky.fnl)
        bootstrap-file (case (search {:prefix :fnl :extension :fnl :modnames [:config.bootstrap.init :config.bootstrap]})
                             [path] path
                             nil (error "Cannot find config.bootstrap"))
        {: global-unmangling} (require :fennel.compiler)
        allowed-globals (vim.tbl_keys (collect [n _ (pairs _G)] (values (global-unmangling n) true)))
        compiler-opts {:verbosity 0
                       :force? true
                       :compiler {:modules {:allowedGlobals allowed-globals :env :_COMPILER} : use-bit-lib}}]
    (fn watch [file callback]
      (let [handle (uv.new_fs_event)]
        (uv.fs_event_start handle file {} #(vim.schedule callback))
        (vim.api.nvim_create_autocmd :VimLeavePre {:callback #(uv.close handle)})))

    (fn compile-bootstrap []
      (match (compile-file bootstrap-file compiler-opts)
        (true code) (let [fc (require :fennel.compiler)]
                      (tset fc.scopes.global.includes :config.bootstrap (.. "(function(...) " code " end)()")))
        (false err) (error err)))

    (compile-bootstrap)

    (fn build-init []
      (build init-file compiler-opts ".+" #(values $1)))
    (fn build-init-bootstrap []
      (compile-bootstrap)
      (build init-file compiler-opts ".+" #(values $1)))
    (fn build-lualine []
      (build fnl-lualine-theme compiler-opts ".+" #(values lua-lualine-theme)))

    (watch bootstrap-file build-init-bootstrap)
    (watch init-file build-init)
    (watch fnl-lualine-theme build-lualine)))

(vim.schedule watcher)

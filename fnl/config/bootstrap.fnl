(local uv (require :luv))
(local windows? (-> (uv.os_uname)
                    (. :version)
                    (: :match :Windows)))
(local path-sep (if windows? :\ :/))

(fn join-paths [...]
  (table.concat [...] path-sep))

(fn helptags [path]
  (let [docpath (join-paths path :doc)]
    (when (uv.fs_stat docpath)
      (vim.cmd.helptags docpath))))

(helptags (vim.fn.stdpath :config))

(-> (vim.fn.stdpath :data)
    (join-paths :lazy)
    (vim.fn.mkdir :p))

(fn git-clone [url dir ?params ?callback]
  (vim.validate {:url       [url       :s]
                 :dir       [dir       :s]
                 :?params   [?params   :t true]
                 :?callback [?callback :f true]})
  (let [install-path (join-paths (vim.fn.stdpath :data) :lazy dir)]
    (if (not (uv.fs_stat install-path))
        (do
          (let [cmd [:git :clone :--filter=blob:none]]
            (when (not= nil ?params)
              (each [_ value (ipairs ?params)]
                (table.insert cmd value)))
            (table.insert cmd url)
            (table.insert cmd install-path)

            (vim.fn.system cmd))

          (when (= vim.v.shell_error 0)
            (helptags install-path)
            (vim.opt.rtp:append install-path))
          (when (= :function (type ?callback))
            (?callback vim.v.shell_error install-path)))
        (do
          (helptags install-path)
          (vim.opt.rtp:append install-path)
          (when (= :function (type ?callback))
            (?callback 0 install-path))))))

(if (= (vim.fn.has "nvim-0.9.0") 0)
    (do
      (git-clone
        "https://github.com/lewis6991/impatient.nvim"
        :impatient.nvim)
      (xpcall
        (fn [] (require :impatient))
        (fn [] (vim.api.nvim_echo [["Error while loading impatient" :ErrorMsg]]
                                  true []))))
    (vim.loader.enable))

(git-clone
  "https://github.com/rktjmp/hotpot.nvim.git"
  :hotpot.nvim
  [:--single-branch])

(git-clone
  "https://github.com/folke/lazy.nvim.git"
  :lazy.nvim
  [:--branch=stable])

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
(local useBitLib (not (has-bit-operators)))

((. (require :hotpot) :setup)
 {:provide_require_fennel true
  :enable_hotpot_diagnostics true
  :compiler {:modules {:correlate true
                       : useBitLib}
             :macros  {:env :_COMPILER
                       :compilerEnv _G
                       :allowedGlobals false
                       : useBitLib}
             :preprocessor nil}})

(let [fennel (require :hotpot.fennel)
      base (join-paths (vim.fn.stdpath :config) :fnl)]
  (set fennel.path
       (table.concat [(join-paths base :?.fnl)
                      (join-paths base :? :init.fnl)
                      fennel.path]
                     ";")))

(fn slurp [path]
  (match (io.open path "r")
    (nil _msg) nil
    f (let [content (f:read "*all")]
        (f:close)
        content)))

(fn additional-macros []
  (local f (require :hotpot.fennel))
  (local fc (require :fennel.compiler))
  (f.eval (slurp (join-paths (vim.fn.stdpath :config)
                             :fnl :config :init-macros.fnl))
          {:env :_COMPILER :scope fc.scopes.compiler}))

(let [fc (require :fennel.compiler)]
  (set fc.scopes.global.macros
       (vim.tbl_deep_extend :force fc.scopes.global.macros (additional-macros))))

(do
  (fn build [files]
    (local {: build} (require :hotpot.api.make))
    (local {: global-unmangling} (require :fennel.compiler))
    (local allowedGlobals (vim.tbl_keys (collect [n _ (pairs _G)]
                                          (values (global-unmangling n) true))))
    (build (vim.fn.stdpath :config)
           {:verbose  true
            :atomic   true
            :force    true
            :compiler {:modules {: allowedGlobals
                                 :correlate true
                                 : useBitLib}}}
           files))

  (fn hook-init-rebuild [file]
    (fn rebuild-on-save [{: buf}]
      (vim.api.nvim_create_autocmd :BufWritePost
                                   {:buffer   buf
                                    :callback #(build [[:init.fnl true]])}))
    (vim.api.nvim_create_autocmd :BufRead
                                 {:pattern  (-> (vim.fn.stdpath :config)
                                                (join-paths file)
                                                (vim.fs.normalize))
                                  :callback rebuild-on-save}))
  (hook-init-rebuild :init.fnl)
  (hook-init-rebuild (join-paths :fnl :config :bootstrap.fnl))
  (let [path (join-paths :fnl :lualine :themes :bluesky.fnl)]
    (fn rebuild-on-save [{: buf}]
      (vim.api.nvim_create_autocmd :BufWritePost
                                   {:buffer   buf
                                    :callback #(build [[path true]])}))
    (vim.api.nvim_create_autocmd :BufRead
                                 {:pattern (-> (vim.fn.stdpath :config)
                                               (join-paths path)
                                               (vim.fs.normalize))
                                  :callback rebuild-on-save})))

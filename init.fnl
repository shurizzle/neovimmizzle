(local path-sep (if (: (. (vim.loop.os_uname) :sysname) :match :Windows) :\ :/))

(lambda path-join [base ...]
  (table.concat [base ...] path-sep))

(lambda dirname [path]
  (vim.fn.fnamemodify path ":h"))

(local init-dir (-> (debug.getinfo 1 :S)
                    (. :source)
                    ((fn [s] [(: s :gsub "^@" "")]))
                    (. 1)
                    (dirname)
                    (vim.loop.fs_realpath)))

(if (not (vim.tbl_contains (vim.opt.rtp:get) init-dir))
    (vim.opt.rtp:append init-dir))

(lambda git-clone [url dir ?params ?callback]
  (let [install-path (path-join (vim.fn.stdpath :data) :lazy dir)]
    (if (not (vim.loop.fs_stat install-path))
        (do
          (let [cmd [:git :clone]]
            (if (not= nil ?params) 
                (each [_ value (ipairs ?params)]
                  (table.insert cmd value)))
            (table.insert cmd url)
            (table.insert cmd install-path)

            (vim.fn.system cmd))

          (if (= vim.v.shell_error 0)
              (vim.opt.rtp:append install-path))
          (if (= :function (type ?callback))
              (?callback vim.v.shell_error install-path)))
        (do
          (vim.opt.rtp:append install-path)
          (if (= :function (type ?callback))
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

(fn additional-macros []
  (local f (require :hotpot.fennel))
  (local fc (require :fennel.compiler))
  (f.eval "(fn test-notify [] `(vim.notify :test :info {:title :macro})) {: test-notify}"
          {:env :_COMPILER :scope fc.scopes.compiler}))

(let [fc (require :fennel.compiler)]
  (set fc.scopes.global.macros
       (vim.tbl_deep_extend :force fc.scopes.global.macros (additional-macros))))

(hotpot.setup {:provide_require_fennel true
               :enable_hotpot_diagnostics true
               :compiler {:modules {:correlate true}
               :macros   {:env :_COMPILER
                          :compiler-env _G}}})

(let [{: global-mangling} (require :fennel.compiler)]
  (each [name f (pairs (require :config.stdlib))]
    (tset _G (global-mangling name) f)
    (tset _G name f)))


(let [fns {:inspect        (fn [what] (-> what (vim.inspect) (print)))
           :has            (fn [what] (not= (vim.fn.has what) 0))
           :executable     (fn [what] (not= (vim.fn.executable what) 0))
           :readonly-table (lambda [t] (setmetatable {} {:__index #(. t $2)}))}
      {: global-mangling}  (require :fennel.compiler)]
  (each [name f (pairs fns)]
    (tset _G (global-mangling name) f)
    (tset _G name f)))

(let [build hotpot.api.make.build
      uv vim.loop
      init-file (path-join init-dir :init.fnl)
      fnl-lualine-theme (path-join init-dir :fnl :lualine :themes :bluesky.fnl)
      lua-lualine-theme (path-join init-dir :lua :lualine :themes :bluesky.fnl)
      {: global-unmangling} (require :fennel.compiler)
      allowed-globals (vim.tbl_keys (collect [n _ (pairs _G)] (values (global-unmangling n) true)))
      compiler-opts {:verbosity 0
                     :compiler {:modules {:allowedGlobals allowed-globals}}}]
  (fn watch [file callback]
    (let [handle (uv.new_fs_event)]
      (uv.fs_event_start handle file {} #(vim.schedule callback))
      (vim.api.nvim_create_autocmd :VimLeavePre {:callback #(uv.close handle)})))

  (fn build-init []
    (build init-file compiler-opts ".+" #(values $1)))
  (fn build-lualine []
    (build fnl-lualine-theme compiler-opts ".+" #(values lua-lualine-theme)))

  (watch init-file build-init)
  (watch fnl-lualine-theme build-lualine))

(require :config.ft)
(require :config.utils)
(require :config.options)
((. (require :config.colors) :setup))
(require :config.keymaps)
((. (require :config.winbar) :setup))
(require :config.plugins)
(require :config.rust)
((. (require :config.lang) :config))

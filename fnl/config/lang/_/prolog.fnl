(local QUERY-CMD ["--quiet" "-g" "pack_list(lsp_server)." "-t" "halt"])

(local INSTALL-CMD
       ["--quiet"
        "-g"
        "pack_install(lsp_server,[interactive(false),silent(true)])."
        "-t"
        "halt"])

(local UPGRADE-CMD
       ["--quiet"
        "-g"
        "pack_remove(lsp_server)."
        "-g"
        "pack_install(lsp_server,[interactive(false),silent(true)])."
        "-t"
        "halt"])

(fn run-cmd [args]
  (fn doit [resolve reject job return-val]
    (if (= 0 return-val)
        (resolve (job:result))
        (reject (..
                  "Command exited with error "
                  return-val
                  ":\n"
                  (table.concat (job:stderr_result) "\n")))
        ))

  (let [{: future} (require :config.future)
        job (fn [...] (: (require :plenary.job) :new ...))
        f (future (fn [resolve reject]
                    (-> (job {:command :swipl
                              : args
                              :on_exit (partial doit resolve reject)})
                        (: :start))))]
    (f:catch (fn [err]
               (vim.notify err vim.log.levels.ERROR {:title :swipl})))
    f))

(fn query []
  (fn extract-lsp-version [line0]
    (var line (trim line0))
    (when (not (empty? line))
      (var [state nv] (vim.split line "%s+" {:trimempty true} 1 2))
      (var [name version] (vim.split nv "@"
                                     {:plain true :trimempty true}
                                     1 2))
      (set state (trim state))
      (set name (trim name))
      (set version (trim version))
      (when (= :lsp_server name)
        (var new (-?> (version:match "%(([^()]+)%)") (trim)))
        (if (or (not new) (empty? new))
            (set new nil)
            (set version (vim.trim (version:match "^[^()]+"))))
        (match state
          :p (do
               (set new version)
               (set version nil))
          :A (set new nil))
        {: name : version : new})))

  (fn not-found? [v]
    (let [{: rejected : resolved} (require :config.future)]
      (if (not v)
          (do
            (local err "Package lsp_server not found")
            (vim.notify err vim.log.levels.ERROR {:title :swipl})
            (rejected err))
          (resolved v))))

  (-> (run-cmd QUERY-CMD)
      (: :and-then (partial some extract-lsp-version))
      (: :and-then not-found?)))

(fn run-install [pack]
  (if (and pack.new (not= pack.version pack.new))
      (do
        (local (okmsg komsg msg cmd)
               (if (and pack.new pack.version)
                   (values :upgraded :upgrade
                           (.. "lsp_server: upgrading to " pack.new)
                           UPGRADE-CMD)
                   (values :installed :install
                           (.. "lsp_server: installing "
                               (or pack.new pack.version))
                           INSTALL-CMD)))
        (fn init [notify]
          (notify msg vim.log.levels.INFO {:title :swipl})
          (run-cmd cmd))
        (fn end [notify ok]
          (if ok
              (notify (.. "lsp_server: " okmsg)
                      vim.log.levels.INFO
                      {:title :swipl})
              (notify (.. "lsp_server: " komsg " failed")
                      vim.log.levels.ERROR
                      {:title :swipl})))
        ((. (require :config.lang.util) :notify-progress) init end))
      ((. (require :config.future) :resolved) nil)))

(var cache nil)

(fn install []
  (when (not cache)
    (set cache (: (query) :and-then (fn [x] (run-install x)))))
  cache)

(fn config []
  (tset (require :lspconfig.configs) :prolog_lsp
        {:default_config {:cmd ["swipl" "-g" "use_module(library(lsp_server))."
                                "-g" "lsp_server:main" "-t" "halt" "--" "stdio"]
                          :filetypes [:prolog]
                          :root_dir ((. (require :lspconfig.util) :root_pattern)
                                     :pack.pl)}
         :docs {:description "https://github.com/jamesnvc/prolog_lsp

Prolog Language Server"}})
  (if (not (executable :swipl))
      ((. (require :config.future) :rejected) "Cannot find the executable")
      (: (install) :and-then
         (fn [] ((. (require :lspconfig) :prolog_lsp :setup) [])))))

{: config}

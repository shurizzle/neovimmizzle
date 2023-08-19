(var *installer* nil)
(local {: is} (require :config.platform))
(local {:join path-join :append path-append} (require :config.path))

(fn get-adapter [package]
  (let [(exe lib) (if
                    is.win (values :.exe :.lib)
                    is.mac (values ""    :.dylib)
                           (values ""    :.so))
        p (package:get_install_path)]
    ((. (require :rust-tools.dap) :get_codelldb_adapter)
     (path-join p :extension :adapter (.. :codelldb exe))
     (path-join p :extension :lldb :lib (.. :liblldb lib)))))

(fn -tools-installer []
  (if (or is.win is.fbsd is.dfbsd is.nbsd is.obsd)
      (do
        (fn set-sysroot-path []
          (fn on-exit [resolve reject job return-val]
            (if (= 0 return-val)
                (vim.schedule
                  (fn []
                    (path-append (path-join (. (job:result) 1) :bin))
                    (resolve nil)))
                (reject (.. "Command exited with error "
                            return-val
                            ":\n"
                            (table.concat (job:stderr_result) "\n")))))

          (let [{:new job} (require :plenary.job)
                {: future} (require :config.future)
                f (future (fn [resolve reject]
                            (job {:command :rustc
                                  :args [:--print :sysroot]
                                  :on_exit (partial on-exit resolve reject)})))]
            (f:catch (fn [err]
                       (vim.notify err vim.log.levels.ERROR {:title :Rust})))
            f))

        (let [i (require :config.lang.installer)
              {:join f-join} (require :config.future)]
          (if (or is.win is.fbsd is.nbsd)
              (f-join [(set-sysroot-path) i.codelldb])
              (f-join [(set-sysroot-path)]))))
      (let [{:join f-join} (require :config.future)
            i (require :config.lang.installer)]
        (f-join [i.rust-analyzer i.codelldb]))))

(fn tools-installer []
  (let [{: rejected : resolved} (require :config.future)]
    (: (-tools-installer) :and-then
       (fn [res]
         (if (. res 1 1)
             (resolved (or (and (. res 2) (. res 2 1) (get-adapter (. res 2 2))) nil))
             (rejected (. res 1 2)))))))

(fn make-installer []
  (fn on_attach [_ buffer]
    (vim.keymap.set :n :<leader>ca "<cmd>RustCodeAction<CR>"
                    {: buffer :silent true})
    (vim.keymap.set :n :K "<cmd>RustHoverAction<CR>"
                    {: buffer :silent true}))

  (: (tools-installer) :and-then
     (fn [adapter]
       ((. (require :rust-tools) :setup)
        {:tools  {:inlay_hints {:auto false}}
         :server {: on_attach
                  :settings {:rust-analyzer {:allFeatures true
                                             :checkOnSave {:command :clippy}}}
                  :dap {: adapter}}}))))

(vim.inspect :culo)

(fn config []
  (if (not *installer*)
      (set *installer* (make-installer)))
  *installer*)

{: config}

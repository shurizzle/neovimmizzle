(autoload [{:join path-join} :config.path
           {: is} :config.platform
           installer :config.lang.installer
           {:setup rust-setup} :rust-tools
           {: get_codelldb_adapter} :rust-tools.dap
           {: mason-get : bin-in-dir} :config.lang.util])

(fn check-rust-analyzer [path]
  (vim.fn.system [path :--version])
  (when (= 0 vim.v.shell_error)
    path))

(fn get-sysroot-path []
  (let [rustc (exepath :rustc)]
    (when rustc
      (let [output (vim.fn.system [rustc :--print=sysroot])]
        (when (= 0 vim.v.shell_error)
          (string.gsub output "\n+$" ""))))))

(fn resolve-local* []
  (let [rust-analyzer (-?> (exepath :rust-analyzer)
                           (check-rust-analyzer))]
    (if rust-analyzer
        rust-analyzer
        (-?> (get-sysroot-path)
             (path-join :bin)
             (bin-in-dir :rust-analyzer)
             (check-rust-analyzer)))))

(fn resolve-local [?cb]
  (vim.validate {:?cb [?cb :f true]})
  (if ?cb
      (let [(ok res) (pcall resolve-local*)]
        (if ok
            (?cb nil res)
            (?cb res nil)))
      (resolve-local*)))

(fn get-adapter [package]
  (let [(exe lib) (if
                    is.win (values :.exe :.lib)
                    is.mac (values ""    :.dylib)
                           (values ""    :.so))
        p (package:get_install_path)]
    (get_codelldb_adapter
      (path-join p :extension :adapter (.. :codelldb exe))
      (path-join p :extension :lldb :lib (.. :liblldb lib)))))

(fn configure [rust-analyzer adapter]
  (fn on_attach [_ buffer]
    (vim.keymap.set :n :<leader>ca "<cmd>RustCodeAction<CR>"
                    {: buffer :silent true})
    (vim.keymap.set :n :K "<cmd>RustHoverAction<CR>"
                    {: buffer :silent true}))

  (fn get-executor []
    (. (require :rust-tools.executors)
       (if (pick-values 1 (pcall require :toggleterm)) :toggleterm :termopen)))

  (local opts
         {:tools  {:inlay_hints {:auto false}
                   :executor    (get-executor)}
          :server {: on_attach
                   :settings {:rust-analyzer {:allFeatures true
                                              :checkOnSave {:command :clippy}}}
                   :dap      {: adapter}}})
  (when rust-analyzer (set opts.server.cmd [rust-analyzer]))

  (rust-setup opts)
  (. (require :lspconfig) :rust_analyzer))

(fn get-rust-analyzer [cb]
  (resolve-local
    (fn [_ bin]
      (if bin
          (cb bin)
          (mason-get :rust-analyzer cb)))))

(fn [cb]
  (var rust-analyzer nil)
  (var adapter nil)
  (fn conf []
    (when (and rust-analyzer adapter)
      (cb (configure (. rust-analyzer 1) (. adapter 1)))))

  (get-rust-analyzer
    (fn [bin]
      (set rust-analyzer [bin])
      (conf)))

  (installer.get
    :codelldb
    (fn [_ p]
      (set adapter [(-?> p (get-adapter))])
      (conf))))

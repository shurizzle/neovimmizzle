(local {: is} (require :config.platform))
(local {:join path-join} (require :config.path))
(local {: mason-get-install-path} (require :config.lang.util))

(var *installer* nil)

(fn get-adapter [package]
  (let [(exe lib) (if is.win (values :.exe :.lib)
                      is.mac (values "" :.dylib)
                      (values "" :.so))
        p (mason-get-install-path package)
        {: get_codelldb_adapter} (require :rustaceanvim.config)]
    (get_codelldb_adapter (path-join p :extension :adapter (.. :codelldb exe))
                          (path-join p :extension :lldb :lib (.. :liblldb lib)))))

(fn configure [rust-analyzer adapter]
  (fn on_attach [_ buffer]
    (vim.keymap.set :n :<leader>ca #(vim.cmd.RustLsp :codeAction)
                    {: buffer :silent true}))

  (fn settings [project-root]
    (local ra (require :rustaceanvim.config.server))
    (ra.load_rust_analyzer_settings project-root
                                    {:settings_file_pattern :rust-analyzer.json}))

  (local default_settings
         {:rust-analyzer {:allFeatures true :checkOnSave {:command :clippy}}})

  (fn cmd []
    (let [cfg (require :rustaceanvim.config.internal)]
      [(or rust-analyzer :rust-analyzer) :--log-file cfg.server.logfile]))

  (fn get-executor []
    (. (require :rustaceanvim.executors)
       (if (pick-values 1 (pcall require :toggleterm)) :toggleterm :termopen)))

  (set vim.g.rustaceanvim
       (fn []
         {:tools {:executor (get-executor)
                  :hover_actions {:replace_builtin_hover true}}
          :server {: settings : default_settings : on_attach : cmd}
          :dap {:adapter (or (-?> adapter get-adapter) false)}})))

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
        (let [{: bin-in-dir} (require :config.lang.util)]
          (-?> (get-sysroot-path)
               (path-join :bin)
               (bin-in-dir :rust-analyzer)
               (check-rust-analyzer))))))

(fn resolve-local [?cb]
  (vim.validate :?cb ?cb :function true)
  (if ?cb
      (let [(ok res) (pcall resolve-local*)]
        (if ok
            (?cb nil res)
            (?cb res nil)))
      (resolve-local*)))

(fn get-rust-analyzer [cb]
  (resolve-local (fn [_ bin]
                   (if bin
                       (cb bin)
                       (let [{: mason-get} (require :config.lang.util)]
                         (mason-get :rust-analyzer cb))))))

(fn install [cb]
  (var rust-analyzer nil)
  (var adapter nil)

  (fn conf []
    (when (and rust-analyzer adapter)
      (configure (. rust-analyzer 1) (. adapter 1))
      (let [{: load} (require :lazy.core.loader)]
        (load [:rustaceanvim] {:plugin :lang}))
      ((. (require :rustaceanvim.lsp) :start))
      (cb)))

  (get-rust-analyzer (fn [bin]
                       (set rust-analyzer [bin])
                       (conf)))
  (local installer (require :config.lang.installer))
  (installer.get :codelldb (fn [_ p]
                             (set adapter [p])
                             (conf))))

(fn installer []
  (if *installer*
      *installer*
      (let [{: callback-memoize} (require :config.lang.util)
            inst (callback-memoize install)]
        (set *installer* inst)
        inst)))

(fn callback [{: buf}]
  ((installer) #nil))

(fn init []
  (vim.api.nvim_create_autocmd :FileType {:pattern :rust : callback}))

{:lazy true :version :^5 :deps [:dap :akinsho/toggleterm.nvim] : init}


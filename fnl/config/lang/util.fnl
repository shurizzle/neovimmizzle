(local {:join path-join : executable? : bin-in-dir} (require :config.path))
(local {: access : scandir : stat} (require :config.fs))
(local {: split : filter-map} (require :config.iter))
(local {: is} (require :config.platform))

(fn callback-memoize [generator]
  (local state {:callbacks []})
  (local (ok err)
         (pcall generator
                (fn [err res]
                  (set state.result [err res])
                  (local cbs state.callbacks)
                  (set state.callbacks nil)
                  (each [_ cb (ipairs cbs)]
                    (vim.schedule #(cb (unpack state.result)))))))
  (when (not ok)
    (set state.result [err nil])
    (set state.callbacks nil))
  (fn [cb]
    (if state.result
        (cb (unpack state.result))
        (table.insert state.callbacks cb))
    nil))

(fn mason-is2? []
  (= 2 (. (require :mason.version) :MAJOR_VERSION)))

(fn mason-bin-prefix []
  (if (mason-is2?)
      (vim.fn.expand :$MASON/bin)
      ((. (require :mason-core.path) :bin_prefix))))

(fn mason-get-install-path [p]
  (if (mason-is2?)
      (vim.fn.expand (.. :$MASON/packages/ p.name))
      (p:get_install_path)))

(fn mason-bin [file]
  (vim.validate :file file :string true)
  (if file
      (bin-in-dir (mason-bin-prefix) file)
      (mason-bin-prefix)))

(fn mason-get [package-name ?bin-name cb]
  (local (?bin-name* cb*) (if (not cb)
                              (values nil ?bin-name)
                              (values ?bin-name cb)))
  (vim.validate :package-name package-name :string)
  (vim.validate :?bin-name ?bin-name* :string true)
  (vim.validate :cb cb* :function)
  (local bin-name (or ?bin-name* package-name))
  (let [installer (require :config.lang.installer)]
    (installer.get package-name
                   (fn [err]
                     (cb* (when (not err) (mason-bin bin-name)))))))

(fn bin-or-install [bins ?package-name ?bin-name cb]
  (var package-name ?package-name)
  (var bin-name ?bin-name)
  (var cb* cb)
  (when (not cb)
    (if (not bin-name)
        (do
          (set cb* package-name)
          (set package-name nil))
        (do
          (set cb* bin-name)
          (set bin-name nil))))
  (when (not package-name)
    (set package-name bins))
  (when (not bin-name)
    (set bin-name package-name))
  (local bins* (if (not (table? bins)) [bins] bins))
  (vim.validate :bins bins* :table)
  (vim.validate :?package-name package-name :string)
  (vim.validate :?bin-name bin-name :string)
  (vim.validate :cb cb* :function)
  (local bin (some exepath bins*))
  (if bin
      (cb* bin)
      (mason-get package-name bin-name cb*)))

(fn conform [name ?opts cb]
  (var ?opts* nil)
  (var cb* nil)
  (if (not cb)
      (set cb* ?opts)
      (do
        (set ?opts* ?opts)
        (set cb* cb)))
  (vim.validate :name name :string)
  (vim.validate :?opts ?opts* [:table :string] true)
  (vim.validate :cb cb* :function)
  (when (string? ?opts*)
    (set ?opts* [?opts*]))
  (fn [bin]
    (local fmt (let [fmt (. (require :conform) :formatters name)]
                 (if fmt
                     fmt
                     (let [(ok fmt) (pcall require
                                           (.. :conform.formatters. name))]
                       (when ok fmt)))))
    (when (and bin fmt)
      (set fmt.command bin))
    (when (and ?opts* fmt)
      (set fmt.args ?opts*))
    (cb* name)))

(fn lint [name ?opts cb]
  (var ?opts* nil)
  (var cb* nil)
  (if (not cb)
      (set cb* ?opts)
      (do
        (set ?opts* ?opts)
        (set cb* cb)))
  (vim.validate :name name :string)
  (vim.validate :?opts ?opts* [:table :string] true)
  (vim.validate :cb cb* :function)
  (when (string? ?opts*)
    (set ?opts* [?opts*]))
  (fn [bin]
    (local lint (let [lint (. (require :lint) :linters name)]
                  (if lint
                      lint
                      (let [(ok lint) (pcall require (.. :lint.linters. name))]
                        (when ok lint)))))
    (when (and bin lint)
      (set lint.cmd bin))
    (when (and ?opts* lint)
      (set lint.args ?opts*))
    (cb* name)))

(local exports {: callback-memoize
                : mason-bin
                : mason-get
                : bin-in-dir
                : bin-or-install
                : conform
                : lint
                : mason-get-install-path})

(fn load-lspconfig []
  (let [{: load} (require :lazy.core.loader)]
    (load [:nvim-lspconfig] {:plugin :lang})))

(local lspconfig (if (has :nvim-0.11)
                     (do
                       (var lsp nil)
                       (fn []
                         (when (not lsp)
                           (load-lspconfig)
                           (set lsp vim.lsp.config))
                         lsp))
                     (do
                       (var lsp nil)
                       (fn []
                         (when (not lsp)
                           (load-lspconfig)
                           (set lsp
                                (let [lspc (require :lspconfig)]
                                  (setmetatable {}
                                                {:__index #(. lspc $2)
                                                 :__newindex #(tset lspc $2 $3)
                                                 :__call #((. lspc $2 :setup) $3)}))))
                         lsp))))

(setmetatable {} {:__index (fn [_ k]
                             (let [v (. exports k)]
                               (if ;;
                                   v v ;;
                                   (= k :lspconfig) (lspconfig)
                                   nil)))
                  :__newindex #nil})

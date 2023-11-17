(autoload [{: scandir : stat} :config.fs
           {:join join-paths} :config.path
           {: get_other_matching_providers} :lspconfig.util
           lsp :config.lang.lsp
           formatter :config.lang.formatter
           linter :config.lang.linter
           {: callback-memoize} :config.lang.util])

(fn require-lang [name]
  (vim.validate {:name [name :s]})
  (local lang (require (.. :config.lang._. name)))
  (set lang.ft (if (not lang.ft) [name]
                   (not (table? lang.ft)) [lang.ft]
                   lang.ft))
  (set lang.lsp (if (not lang.lsp) []
                    (not (table? lang.lsp)) [lang.lsp]
                    lang.lsp))
  (set lang.fmt (if (not lang.fmt) []
                    (not (table? lang.fmt)) [lang.fmt]
                    lang.fmt))
  (set lang.lint (if (not lang.lint) []
                     (not (table? lang.lint)) [lang.lint]
                     lang.lint))
  lang)

(fn run-config [name cb]
  (local lang (require-lang name))
  (var state {:lsp [] :fmt [] :lint [] :ft (copy lang.ft)})
  (var count 1)
  (fn continue []
    (dec! count)
    (when (= 0 count)
      (let [fmts (vim.tbl_values state.fmt)]
        (each [_ ft (ipairs lang.ft)]
          (tset (. (require :conform) :formatters_by_ft) ft (copy fmts))))
      (let [lints (vim.tbl_values state.lint)]
        (each [_ ft (ipairs lang.ft)]
          (tset (. (require :lint) :linters_by_ft) ft (copy lints))))

      (if (function? lang.config)
          (lang.config state #(cb state))
          (cb state))))

  (each [_ lsp-name (ipairs lang.lsp)]
    (let [f (. lsp lsp-name)]
      (if f
          (do
            (inc! count)
            (f (fn [res]
                 (tset state.lsp lsp-name res)
                 (continue))))
          (vim.notify (.. "LSP " lsp-name " not found")
                          vim.log.levels.ERROR {:title :lang}))))

  (each [_ fmt (ipairs lang.fmt)]
    (let [f (. formatter fmt)]
      (if f
          (do
            (inc! count)
            (f (fn [res]
                 (tset state.fmt fmt res)
                 (continue))))
          (vim.notify (.. "formatter " fmt " not found")
                      vim.log.levels.ERROR {:title :lang}))))

  (each [_ lint (ipairs lang.lint)]
    (let [f (. linter lint)]
      (if f
          (do
            (inc! count)
            (f (fn [res]
                 (tset state.lint lint res)
                 (continue))))
          (vim.notify (.. "linter " lint " not found")
                      vim.log.levels.ERROR {:title :lang}))))

  (continue))

(local *configs* [])

(fn config-get [name]
  (let [config (. *configs* name)]
    (if config
        config
        (let [c (callback-memoize (partial run-config name))]
          (tset *configs* name c)
          c))))

(fn setup* [name]
  (local lang (require-lang name))
  (local auname (.. "lang-init-" name))

  (if (function? lang.init) (lang.init))

  (fn launch [bufnr]
    (each [_ config (ipairs (get_other_matching_providers
                              (vim.api.nvim_buf_get_option bufnr :filetype)))]
      (config.manager:try_add_wrapper bufnr))
    (vim.api.nvim_buf_call bufnr #((. (require :lint) :try_lint))))

  (vim.api.nvim_create_augroup auname {:clear true})
  (fn callback [{: buf}]
    ((config-get name)
     (fn []
       (pcall vim.api.nvim_del_augroup_by_name auname)
       (launch buf))))

  (vim.api.nvim_create_autocmd
    :FileType
    {:pattern (table.concat lang.ft ",")
     : callback
     :group auname
     :desc (.. "Configure " name " language")}))

(fn setup [name]
  (let [(ok err) (pcall setup* name)]
    (when (not ok)
      (vim.notify (.. name ": " err)
                  vim.log.levels.ERROR {:title :lang}))))

(fn get-langs []
  (var langs [])
  (fn scan [dir ?ext]
    (vim.validate {:?ext [?ext :s true]})
    (local ext (or ?ext (.. :. dir)))
    (local base (join-paths (vim.fn.stdpath :config) dir :config :lang :_))
    (local offset (- (length ext)))
    (local (ok it) (pcall scandir base))
    (when (and ok it)
      (each [entry it]
        (if
          (and (= (entry:sub offset) ext)
               (= :file (?. (stat (join-paths base entry)) :type)))
            (tset langs (entry:sub 1 (- offset 1)) true)
          (let [(ok md) (pcall stat (join-paths base entry (.. :init ext)))]
            (and ok (= :file (?. md :type))))
            (tset langs entry true)))))
  (scan :fnl)
  (scan :lua)
  (set langs (vim.tbl_keys langs))
  (table.sort langs)
  langs)

(fn config []
  (local signs [{:name :DiagnosticSignError :text ""}
                {:name :DiagnosticSignWarn  :text ""}
                {:name :DiagnosticSignHint  :text ""}
                {:name :DiagnosticSignInfo  :text ""}])

  (each [_ sign (ipairs signs)]
    (vim.fn.sign_define sign.name {:texthl sign.name
                                   :text   sign.text
                                   :numhl  ""}))

  (vim.diagnostic.config {; disable virtual text
                          :virtual_text     false
                          ; show signs
                          :signs            {:active signs}
                          :update_in_insert true
                          :underline        true
                          :severity_sort    true
                          :float            {:focusable false
                                             :style     :minimal
                                             :border    :rounded
                                             :source    :always
                                             :header    ""
                                             :prefix    ""}})

  (tset vim.lsp.handlers :textDocument/hover
        (vim.lsp.with vim.lsp.handlers.hover {:border :rounded}))

  (tset vim.lsp.handlers :textDocument/signatureHelp
        (vim.lsp.with vim.lsp.handlers.signature_help {:border :rounded}))

  (let [group (vim.api.nvim_create_augroup :lsp_document {:clear true})]
    (vim.api.nvim_create_autocmd :CursorHold
                                 {:pattern  [:*]
                                  :callback #(vim.diagnostic.open_float)
                                  : group})
    (vim.api.nvim_create_autocmd :CursorMoved
                                 {:pattern  [:*]
                                  :callback #(vim.lsp.buf.clear_references)
                                  : group}))

  (let [{: load} (require :lazy.core.loader)]
    (load [:nlsp-settings.nvim :cmp-nvim-lsp :conform :lint]
          {:plugin :lang}))

  (require :config.lang.custom.crates)
  (each [_ lang (ipairs (get-langs))]
    (setup lang)))

{: config}

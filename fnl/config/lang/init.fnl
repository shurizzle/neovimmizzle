(autoload [Future :config.future])

(lambda deferred-config [lang]
  (vim.validate {:lang [lang :s]})
  (let [l (require (.. :config.lang._. lang))
        fts (table.concat (or l.filetypes [lang]) ",")
        auname (.. :LSP_ lang)]
    (fn launch [bufnr]
      (each [_ config (ipairs ((. (require :lspconfig.util)
                                  :get_other_matching_providers)
                               (vim.api.nvim_buf_get_option bufnr :filetype)))]
        (config.manager:try_add_wrapper bufnr)))

    (vim.api.nvim_create_augroup auname {:clear true})
    (vim.api.nvim_create_autocmd
      :Filetype
      {:pattern fts
       :callback (fn []
                   (let [bufnr (vim.api.nvim_get_current_buf)]
                     (: (Future.pcall l.config)
                        :finally
                        (fn [ok res0]
                          (if (not ok)
                              (let [res (if (string? res0)
                                            res0
                                            (vim.inspect res0))]
                                (vim.notify (.. lang ": " res)
                                            vim.log.levels.ERROR
                                            {:title :LSP})))
                          (pcall vim.api.nvim_del_augroup_by_name auname)
                          (let [(ok err) (launch bufnr)]
                            (when (and (not ok) err)
                              (vim.notify (tostring err)
                                          vim.log.levels.ERROR)))))))
       :group auname
       :desc (.. "Configure " lang " LSP")})))

(lambda -config [lang]
  (vim.validate {:lang [lang :s]})
  (let [l (require (.. :config.lang._. lang))]
    (if l.setup
        (let [(ok res) (pcall l.setup)]
          (if (not ok)
              (vim.notify (.. lang ": " (if (not (string? res)) (vim.inspect res) res))
                          vim.log.levels.ERROR
                          {:title :LSP})
              (if (function? (?. res :finally))
                  (res:finally (fn [ok res]
                                 (if (not ok)
                                     (vim.notify (.. lang ": "
                                                     (if (not (string? res))
                                                         (vim.inspect res)
                                                         res))
                                                 vim.log.levels.ERROR
                                                 {:title :LSP})))))))
        (deferred-config lang))))

(fn format [?options]
  (local options (or ?options []))
  (set options.bufnr (or options.bufnr (vim.api.nvim_get_current_buf)))
  (set options.timeout_ms (or options.timeout_ms 4000))
  (let [clients0 (vim.lsp.get_active_clients {:id options.id
                                             :bufnr options.bufnr
                                             :name options.name})
        clients1 (if options.filter 
                    (vim.tbl_filter options.filter clients0)
                    clients0)
        clients (vim.tbl_filter #($1.supports_method :textDocument/formatting) clients1)]
    (if (not= 0 (length clients)) (vim.lsp.buf.format options))))

(fn file-type [path]
  (vim.validate {:path [path :s]})
  (match (vim.loop.fs_stat path)
    (where stat (not= nil stat)) stat.type))

(fn is-dir [path]
  (= :directory (file-type path)))

(fn is-file [path]
  (= :file (file-type path)))

(fn config []
  (local signs [{:name :DiagnosticSignError :text ""}
                {:name :DiagnosticSignWarn :text ""}
                {:name :DiagnosticSignHint :text ""}
                {:name :DiagnosticSignInfo :text ""}])

  (each [_ sign (ipairs signs)]
    (vim.fn.sign_define sign.name {:texthl sign.name :text sign.text :numhl ""}))

  (local diag_config {; disable virtual text
                      :virtual_text false
                      ; show signs
                      :signs {:active signs}
                      :update_in_insert true
                      :underline true
                      :severity_sort true
                      :float {:focusable false
                              :style :minimal
                              :border :rounded
                              :source :always
                              :header ""
                              :prefix ""}})

  (vim.diagnostic.config diag_config)

  (tset vim.lsp.handlers :textDocument/hover
        (vim.lsp.with vim.lsp.handlers.hover {:border :rounded}))

  (tset vim.lsp.handlers :textDocument/signatureHelp
        (vim.lsp.with vim.lsp.handlers.signature_help {:border :rounded}))

  (vim.api.nvim_create_user_command :Format
                                    (fn [] (format {:async true}))
                                    {:desc "Format buffer"})

  (let [group (vim.api.nvim_create_augroup :lsp_document {:clear true})]
    (vim.api.nvim_create_autocmd [:CursorHold] {:pattern [:*]
                                                :callback (fn [] (vim.diagnostic.open_float))
                                                : group})
    (vim.api.nvim_create_autocmd [:CursorMoved] {:pattern [:*]
                                                 :callback (fn [] (vim.lsp.buf.clear_references))
                                                 : group})
    (vim.api.nvim_create_autocmd [:BufWritePre] {:pattern [:*]
                                                 :callback (fn [] (format {:async false}))
                                                 : group}))
  (let [{:join path-join : init-dir :file file-name} (require :config.path)
        lang-done []]
    (fn -config- [lang]
      (if (not (. lang-done lang))
          (do
            (-config lang)
            (tset lang-done lang true))))

    (fn config-path [path ext]
      (match (: (file-name path) :match (.. "(.+)%." ext))
        nil (if (is-file (path-join path (.. :init. ext)))
                (-config- (file-name path)))
        lang (if (is-file path)
                 (-config- lang))))

    (macro scandir [[cursor path] & body]
      `(let [dir-handle# (vim.loop.fs_scandir ,path)]
         (if dir-handle#
             (while true
               (var ,cursor (vim.loop.fs_scandir_next dir-handle#))
               (if (not ,cursor) (lua :break))
               (set ,cursor (path-join ,path ,cursor))
               ,body))))

    (fn scan-lang-dir [lang ?ext]
      (let [ext (or ?ext lang)]
        (scandir [path (path-join init-dir lang :config :lang :_)]
                 (config-path path ext))))

    (scan-lang-dir :lua)
    (scan-lang-dir :fnl)))

{: format
 : config}

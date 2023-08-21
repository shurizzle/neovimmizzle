(local u (require :config.winbar.util))
(local s (require :config.winbar.lsp.state))
(local t (require :config.winbar.lsp.transport))

(var request nil)
(var augroup nil)

(fn fire-event [?bufnr]
  (local bufnr (u.ensure-bufnr ?bufnr))
  (vim.api.nvim_buf_call
    bufnr
    (fn []
      (vim.api.nvim_exec_autocmds :User
                                  {:pattern :NewDocumentSymbols}))))

(fn handler [changedtick err data info]
  (var defer 0)
  (xpcall
    (fn []
      (if
        err (set defer 750)
        data (do
               (local state (s.get-or-create info.bufnr))
               (set state.changedtick changedtick)
               (when (state:set-data data) (fire-event info.bufnr)))))
    (fn [err]
      (vim.api.nvim_echo [[(if (string? err) err (vim.inspect err))
                           :ErrorMsg]]
                         true [])))
  (let [cb (fn [] (request info.bufnr))]
    (if (not= 0 defer)
        (vim.defer_fn cb defer)
        (vim.schedule cb)))
  false)

(fn fn-request [?bufnr]
  (local bufnr (u.ensure-bufnr ?bufnr))
  (local state (s.get-or-create bufnr))

  (when (not state.requesting)
    (set state.requesting true)

    (if (u.buf-is-visible bufnr 0)
        (do
          (local changedtick (vim.api.nvim_buf_get_var bufnr :changedtick))

          (if (not= state.changedtick changedtick)
              (do
                (local (ok id) (t.request bufnr (fn [...]
                                                  (set state.requesting false)
                                                  (set state.request-id nil)
                                                  (handler changedtick ...))))
                (set state.request-id id)
                (when (not ok) (set state.requesting false)))
              (set state.requesting false)))
        (set state.requesting false))))
(set request fn-request)

(fn delete [?bufnr]
  (local bufnr (u.ensure-bufnr ?bufnr))
  (local state (s.get bufnr))
  (when state
    (when state.request-id
      (let [client (and (. state.servers 1)
                        (vim.lsp.get_client_by_id (. state.servers 1 :id)))]
        (when client
          (client.cancel_request state.request-id))))
    (set state.request-id nil)
    (set state.data nil)
    (set state.changedtick 0)
    (set state.requesting false)
    (s.delete bufnr))
  false)

(fn detach [client ?bufnr]
  (local bufnr (u.ensure-bufnr ?bufnr))
  (local state (s.get bufnr))
  (when state
    (local (id server) (state:remove-server-by-id client.id))
    (when (= 1 id)
      (when (and (= server.id client.id) state.request-id)
        (client.cancel_request state.request-id))

      (set state.request-id nil)
      (set state.data nil)
      (set state.changedtick 0)
      (set state.requesting false)
      (fire-event bufnr))
    (if (empty? state.servers)
        (s.delete bufnr)
        (request bufnr))))

(fn attach [client ?bufnr]
  (local mkaucmd vim.api.nvim_create_autocmd)
  (when client.server_capabilities.documentSymbolProvider
    (local bufnr (u.ensure-bufnr ?bufnr))
    (local state (s.get-or-create bufnr))
    (when (state:add-server client.id client.name)
      (if (> (vim.tbl_count state.servers) 1)
          (vim.api.nvim_echo [[(.. "winbar: Failed to attach to "
                                   client.name
                                   "("
                                   client.id
                                   ") for current buffer. Already attached to "
                                   (. state.servers 1 :name)
                                   "("
                                   (. state.servers 1 :id)
                                   ")")
                               :ErrorMsg]]
                             true
                             [])
          (do
            (mkaucmd [:BufEnter
                      :BufWritePost
                      :TextChanged
                      :TextChangedI
                      :TextChangedP]
                     {:callback #(request $1.buf)
                      :group augroup
                      :buffer bufnr})
            (mkaucmd :BufWipeout
                     {:callback #(delete $1.buf)
                      :group augroup
                      :buffer bufnr})
            (mkaucmd :LspDetach
                     {:callback (fn [opts]
                                  (-?> (vim.lsp.get_client_by_id opts.data.client_id)
                                       (detach opts.buf))
                                  false)
                      :group augroup
                      :buffer bufnr})
            (each [_ b (ipairs (vim.api.nvim_list_bufs))]
              (request b))))))
  false)

(local init
       (once
         (fn []
           (fn cb [opts]
             (-?> (vim.lsp.get_client_by_id opts.data.client_id)
                  (attach opts.buf))
             false)
           (vim.api.nvim_create_autocmd
             :LspAttach
             {:callback cb})
           (set augroup (vim.api.nvim_create_augroup
                          :winbar-lsp
                          {:clear false})))))

(fn setup []
  (init)
  (each [_ b (ipairs (vim.api.nvim_list_bufs))]
    (vim.lsp.for_each_buffer_client
      b
      (fn [client _ bufnr] (attach client bufnr)))))

(fn get-data [bufnr] (-?> (s.get bufnr) (. :data)))

{: setup
 : get-data}

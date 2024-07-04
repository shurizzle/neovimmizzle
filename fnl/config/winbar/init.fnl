(local {: ensure-winnr : buf-get-windows : stl-escape} (require :config.winbar.util))
(local {: is} (require :config.platform))

(local excluded-buftypes [:nofile :help])

(local excluded-filetypes [])
(local winbar-fmt "%{%v:lua.require'config.winbar'()%}")
(local *cmd-sep* (if is.win "&" ";"))

(fn breadcrumbs [?winid]
  ((. (require :config.winbar.breadcrumbs) :render) ?winid))

(fn name [bufnr]
  (vim.validate {:bufnr [bufnr :n]})

  (fn term [name]
    (fn base [name]
      (case (strip-prefix name "term://")
        (where name (not (nil? name)))
        (let [(_ second) (string.match name "([^:]*):(.*)")]
          (if (not (empty? second))
              second
              name))))

    (fn toggleterm [name]
      (let [(first second) (string.match name
                                         (.. "([^" *cmd-sep* "]*)" *cmd-sep*
                                             "(.*)"))]
        (if (and first second (starts-with? second "#toggleterm#"))
            first
            name)))

    (-?> name (base) (toggleterm)))

  (fn fallback [name]
    (when (not (empty? name))
      (vim.fn.fnamemodify name ":.")))

  (let [name (vim.api.nvim_buf_get_name bufnr)]
    (when name
      (-?> (or (term name) (fallback name)) (stl-escape)))))

(fn len [?str]
  (if ?str
      (. (vim.api.nvim_eval_statusline ?str {:winid 0 :maxwidth 0}) :width)
      0))

(fn winbar [?winid]
  (let [winid (ensure-winnr (or ?winid 0))]
    (.. (name (vim.api.nvim_win_get_buf winid))
        (match (breadcrumbs winid)
          (where n (not (empty? n))) (.. " %#BreadcrumbsSeparator#>%* " n)
          _ ""))))

(fn redraw-status [winnr]
  (vim.schedule (fn []
                  (pcall vim.api.nvim_win_call winnr #(vim.cmd :redrawstatus)))))

(fn set-winbar [winnr]
  (when (empty? (vim.api.nvim_get_option_value :winbar
                                               {:scope :local :win winnr}))
    (vim.api.nvim_set_option_value :winbar winbar-fmt
                                   {:scope :local :win winnr})
    (redraw-status winnr)))

(fn unset-winbar [winnr]
  (when (not (empty? (vim.api.nvim_get_option_value :winbar
                                                    {:scope :local :win winnr})))
    (vim.api.nvim_set_option_value :winbar nil {:scope :local :win winnr})
    (redraw-status winnr)))

(fn buf-set-winbar [bufnr]
  (each [_ winnr (ipairs (buf-get-windows bufnr))]
    (set-winbar winnr)))

(fn buf-unset-winbar [bufnr]
  (each [_ winnr (ipairs (buf-get-windows bufnr))]
    (unset-winbar winnr)))

(fn options [?opts]
  (var opts (or ?opts {}))
  (set opts.buf (or opts.buf (vim.api.nvim_get_current_buf)))
  (set opts.buftype
       (or opts.buftype (vim.api.nvim_buf_get_option opts.buf :buftype) ""))
  (set opts.filetype
       (or opts.filetype (vim.api.nvim_buf_get_option opts.buf :filetype) ""))
  (set opts.name (or opts.name (vim.api.nvim_buf_get_name opts.buf) ""))
  opts)

(fn buf-changed [opts]
  (let [opts (options opts)]
    (if (or (vim.tbl_contains excluded-buftypes opts.buftype)
            (vim.tbl_contains excluded-filetypes opts.filetype)
            (empty? opts.name))
        (buf-unset-winbar opts.buf)
        (buf-set-winbar opts.buf))))

(fn setup []
  (vim.cmd "function GoToDocumentSymbol(a, b, c, d)
  call v:lua.require('config.winbar.breadcrumbs').jump(a:a, a:b, a:c, a:d)
endfunction")
  ((. (require :config.winbar.lsp) :setup))
  ((. (require :config.winbar.breadcrumbs) :setup))
  (set vim.opt.winbar nil)
  (vim.api.nvim_create_autocmd :OptionSet
                               {:pattern [:buftype :filetype]
                                :callback (fn [opts]
                                            (var k
                                                 (match opts.match
                                                   :buftype :buftype
                                                   :filetype :filetype))
                                            (when k
                                              (buf-changed {:buf (vim.api.nvim_get_current_buf)
                                                            k vim.v.option_new})))})
  (vim.api.nvim_create_autocmd [:BufWinEnter :BufWritePost :BufReadPost]
                               {:callback (fn [{: buf}] (buf-changed {: buf}))})
  (vim.api.nvim_create_autocmd :BufNew
                               {:callback (fn [{: buf : file}]
                                            (when (and (vim.api.nvim_buf_is_valid buf)
                                                       (not (empty? file)))
                                              (buf-changed {: buf :name file})))})
  (each [_ winid (ipairs (vim.api.nvim_list_wins))]
    (when (vim.api.nvim_win_is_valid winid)
      (local bufnr (vim.api.nvim_win_get_buf winid))
      (when (vim.api.nvim_buf_is_valid bufnr)
        (xpcall #(vim.api.nvim_win_call winid #(buf-changed {:buf bufnr}))
                #(vim.api.nvim_echo [[(if (not (string? $1)) (vim.inspect $1)
                                          $1)
                                      :ErrorMsg]]
                                    true []))))))

(setmetatable {: breadcrumbs : name : len : winbar : setup}
              {:__call (fn [_ ...] (winbar ...)) :__newindex (fn [] nil)})

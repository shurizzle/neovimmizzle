(fn format [args]
  (local range
         (when (not= -1 args.count)
           (let [end-line (. (vim.api.nvim_buf_get_lines 0 (- args.line2 1)
                                                         args.line2 true)
                             1)]
             {:start [args.line1 0] :end [args.line2 (end-line:len)]})))
  ((. (require :conform) :format) {:async true :lsp_fallback true : range}))

(fn disable-autoformat []
  (set vim.g.autoformat false))

(fn enable-autoformat []
  (set vim.g.autoformat true))

(fn buf-disable-autoformat []
  (set vim.b.autoformat false))

(fn buf-enable-autoformat []
  (set vim.b.autoformat true))

(fn init []
  (set vim.o.formatexpr "v:lua.require'conform'.formatexpr()")
  (vim.api.nvim_create_user_command :Format format {:range true})
  (vim.api.nvim_create_user_command :DisableAutoformat disable-autoformat [])
  (vim.api.nvim_create_user_command :EnableAutoformat enable-autoformat [])
  (vim.api.nvim_create_user_command :BufDisableAutoformat
                                    buf-disable-autoformat [])
  (vim.api.nvim_create_user_command :BufEnableAutoformat buf-enable-autoformat
                                    []))

(fn truish-or-nil? [x]
  (not (matches x (or 0 false))))

(fn format? [bufnr]
  (and (truish-or-nil? vim.g.autoformat)
       (truish-or-nil? (?. vim :b bufnr :autoformat))))

(fn format_on_save [bufnr]
  (when (format? bufnr)
    (let [timeout_ms (match (?. vim :bo bufnr :filetype)
                       (where (or :blade :kotlin :prettier :fnlfmt)) 2000
                       _ 500)]
      {: timeout_ms :lsp_fallback true})))

{:lazy true
 :cmd [:ConformInfo]
 : init
 :main :conform
 :opts {:formatters_by_ft {:_ [:trim_whitespace]} : format_on_save}}


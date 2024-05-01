(fn init []
  (set vim.o.formatexpr "v:lua.require'conform'.formatexpr()")
  (vim.api.nvim_create_user_command :Format
                                    (fn [args]
                                      (local range
                                             (if (not= -1 args.count)
                                                 (let [end-line (. (vim.api.nvim_buf_get_lines 0
                                                                                               (- args.line2
                                                                                                  1)
                                                                                               args.line2
                                                                                               true)
                                                                   1)]
                                                   {:start [args.line1 0]
                                                    :end [args.line2
                                                          (end-line:len)]})
                                                 nil))
                                      ((. (require :conform) :format) {:async true
                                                                       :lsp_fallback true
                                                                       : range}))
                                    {:range true}))

(fn format_on_save [bufnr]
  (var timeout_ms 500)
  (match (. vim :bo bufnr :filetype)
    (where (or :blade :kotlin :prettier :fnlfmt)) (set timeout_ms 2000))
  {: timeout_ms :lsp_fallback true})

{:lazy true
 :cmd [:ConformInfo]
 : init
 :main :conform
 :opts {:formatters_by_ft {:_ [:trim_whitespace]} : format_on_save}}

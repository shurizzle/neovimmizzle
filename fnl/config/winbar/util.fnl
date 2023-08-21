(fn ensure-bufnr [bufnr]
  (vim.validate {:bufnr [bufnr :n]})
  (if (= 0 bufnr) (vim.api.nvim_get_current_buf) bufnr))

(fn ensure-winnr [winnr]
  (vim.validate {:winnr [winnr :n]})
  (if (= 0 winnr) (vim.api.nvim_get_current_win) winnr))

(fn ensure-tabnr [tabnr]
  (vim.validate {:tabnr [tabnr :n]})
  (if (= 0 tabnr) (vim.api.nvim_get_current_tabpage) tabnr))

(fn buf-get-windows [?bufnr]
  (local bufnr (ensure-bufnr ?bufnr))
  (vim.tbl_filter #(= (vim.api.nvim_win_get_buf $1) bufnr)
                  (vim.api.nvim_list_wins)))

(fn buf-get-tabpages [bufnr]
  (vim.tbl_map vim.api.nvim_win_get_tabpage
               (buf-get-windows bufnr)))

(fn win-is-visible [winnr tabnr]
  (= (vim.api.nvim_win_get_tabpage winnr) (ensure-tabnr tabnr)))

(fn buf-is-visible [bufnr ?tabnr]
  (local tabnr (ensure-tabnr ?tabnr))
  (some #(= $1 tabnr) (buf-get-tabpages bufnr)))

(fn stl-escape [str]
  (if (string? str)
      (select 1 (str:gsub "%%" "%%%%"))
      str))

(lambda trace-callback [f]
  (vim.validate {:f [f :f]})
  (fn on-error [err]
    (vim.api.nvim_echo [[(if (string? err) err (vim.inspect err))
                         :ErrorMsg]]
                       true
                       []))
  (fn [& args]
    (let [[ok & res] [(pcall (fn [] (f (unpack args))))]]
      (if ok
          (unpack res)
          (do
            (on-error (. res 1))
            (error (unpack res)))))))

{: ensure-bufnr
 : ensure-winnr
 : ensure-tabnr
 : buf-get-windows
 : buf-get-tabpages
 : win-is-visible
 : buf-is-visible
 : stl-escape}

(var *vertical-wins* [])
(var *sb* nil)

(fn is-open []
  (local windows (require :dapui.windows))
  (each [_ w (ipairs windows.layouts)]
    (when (w:is_open)
      (lua "return true")))
  false)

(fn get-vertical-windows []
  (local windows (require :dapui.windows))
  (var ws [])
  (each [_ l (ipairs windows.layouts)]
    (when (and (= l.layout_type :vertical) (l:is_open))
      (each [_ w (ipairs l.opened_wins)]
        (tset ws w true))))
  ws)

(fn config []
  (local dapui (require :dapui))
  (local windows (require :dapui.windows))
  (local sidebar (require :config.sidebar))

  (fn on-close []
    (when (and *sb* *sb*.close)
      (let [close *sb*.close]
        (set *sb* nil)
        (close))))

  (fn on-win-close [winid]
    (when (not (empty? *vertical-wins*))
      (tset *vertical-wins* winid nil)
      (when (empty? *vertical-wins*)
        (on-close))))

  (fn on-win-resize [winid]
    (when (and (. *vertical-wins* winid) *sb* *sb*.resize)
      (*sb*.resize (inc (vim.api.nvim_win_get_width winid)))))

  (vim.api.nvim_create_autocmd :WinClosed
                               {:pattern "*"
                                :callback (fn [{: file}]
                                            (on-win-close (tonumber file))
                                            false)})
  (vim.api.nvim_create_autocmd :WinResized
                               {:pattern "*"
                                :callback (fn [{: file}]
                                            (on-win-resize (tonumber file))
                                            false)})
  (let [old-close dapui.close]
    (set dapui.close (fn [...]
                       (old-close ...)
                       (on-close))))
  (let [old-open dapui.open]
    (set dapui.open
         (fn open [...]
           (local args [...])
           (sidebar.register :Debug
                             (fn [close]
                               (if (empty? *vertical-wins*)
                                   (do
                                     (set *sb* nil)
                                     (close))
                                   (do
                                     (set *sb* {: close})
                                     (each [w _ (pairs *vertical-wins*)]
                                       (vim.api.nvim_win_close w true)))))
                             (fn [sb]
                               (set *sb* sb)
                               (old-open (unpack args))
                               (set *vertical-wins* (get-vertical-windows)))))))
  (set dapui.old-toggle dapui.toggle)
  (set dapui.toggle (fn toggle []
                      (if (is-open)
                          (if (empty? *vertical-wins*)
                              (dapui.open)
                              (dapui.close))
                          (dapui.open))))
  (dapui.setup))

(fn init []
  (vim.keymap.set :n :<space>d #((. (require :dapui) :toggle))
                  {:silent true :noremap true :desc "Toggle dapui"}))

{:lazy true :deps [:dap :nvim-neotest/nvim-nio] : init : config}

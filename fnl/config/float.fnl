(local *curved-borders* ["╭" "─" "╮" "│" "╯" "─" "╰" "│"])
(local *float-config* {:relative :editor
                       :style :minimal
                       :border *curved-borders*})

; TODO:
; set focus on open
; handle VimResized event
; close on unfocus

; manager

(var state nil)

(fn mksize []
  (let [width (math.ceil (math.min vim.o.columns (math.max 80 (- vim.o.columns 20))))
        height (math.ceil (math.min vim.o.lines (math.max 20 (- vim.o.lines 10))))
        row (math.ceil (- (* (- vim.o.lines height) 0.5) 1))
        col (math.ceil (- (* (- vim.o.columns width) 0.5) 1))]
    [row col width height]))

(fn mkoptions []
  (let [[row col width height] (mksize)]
    (vim.tbl_deep_extend :force *float-config* {: row : col : width : height})))

(fn validate-bufnr [bufnr]
  (if
    (not (number? bufnr))
      (values false (.. "expected number, got " (type bufnr)))
    (and (not= 0 bufnr) (not (vim.api.nvim_buf_is_valid bufnr)))
      (values false "expected valid buffer number")
    true))

(fn close-current-term []
  (if state
      (let [res (if state.on-close
                    (do
                      (state.on-close)
                      true)
                    false)]
        (set state nil)
        res)
      false))

(fn close-win []
  (let [winid (?. state :winid)]
    (if (vim.api.nvim_win_is_valid winid)
        (do
          (vim.api.nvim_win_close winid true)
          true)
        false)))

(fn extract-bufnr [name term]
  (if
    (and (table? term) (select 1 (validate-bufnr term.bufnr)))
      term.bufnr
    (and (number? term) (select 1 (validate-bufnr term.bufnr)))
      term
    (error (.. name ": expected bufnr or term, got " (type term)))))

(fn close [?term]
  (match (-?>> ?term (extract-bufnr :?term))
    nil (close-win)
    (where bufnr (= bufnr (?. state :bufnr))) (close-win)
    _ false))

(fn is-open [?term]
  (and state
       (vim.api.nvim_win_is_valid state.winid)
       (vim.api.nvim_buf_is_valid state.bufnr)
       (or (not ?term) (=
                         (let [(ok bufnr) (pcall extract-bufnr :?term ?term)]
                           (if ok bufnr nil))
                         state.bufnr))))

(fn set-term [term]
  (fn extract-on-close [term]
    (match (?. term :on-close)
      nil nil
      (where f (function? f)) (fn [] (term:on-close))
      _ (error "buffer: invalid on-close callback")))

  (fn call-on-open [term]
    (match (?. term :on-open)
      nil nil
      (where f (function? f)) (term:on-open)
      _ (error "buffer: invalid on-close callback")))

  (fn extract-state [term]
    (if
      (and (table? term) (select 1 (validate-bufnr term.bufnr)))
        {:bufnr term.bufnr :on-close (extract-on-close term)}
      (and (number? term) (select 1 (validate-bufnr term)))
        {:bufnr term}
      (error (.. "buffer: expected bufnr or term, got " (type term)))))

  (fn mkwin [bufnr]
    (match (?. state :winid)
      (where winid (and (not (nil? winid))
                        (not= 0 winid)
                        (vim.api.nvim_win_is_valid winid)))
        (do
          (vim.api.nvim_win_set_buf winid bufnr)
          winid)
      _ (let [winid (vim.api.nvim_open_win bufnr true (mkoptions))]
          (vim.api.nvim_create_autocmd
            :WinClosed
            {:pattern (tostring winid)
             :callback (fn [] (close-current-term) false)})
          (when (not state) (set state []))
          (set state.winid winid)
          winid)))

  (let [{: bufnr : on-close} (extract-state term)]
    (when (not= bufnr (?. state :bufnr))
      (let [close-old (or (?. state :on-close) (const nil))]
        (call-on-open term)
        (set state {: bufnr : on-close :winid (mkwin bufnr)})
        (close-old))))
  nil)

;; term

(fn run-in-buffer [bufnr f]
  (vim.validate {:bufnr [bufnr validate-bufnr]
                 :f [f :f]})
  (if (not= bufnr (vim.api.nvim_get_current_buf))
      (vim.api.nvim_buf_call bufnr f)
      (f)))

(fn make-cmd [raw-cmd]
  (if
    (nil? raw-cmd) vim.o.shell
    (function? raw-cmd) (raw-cmd)
    raw-cmd))

(fn mkbuf []
  (let [bufnr (vim.api.nvim_create_buf false false)]
    (tset (. vim.bo bufnr) :buflisted false)
    bufnr))

(fn term-bufnr [term]
  (fn register-unload [term]
    (vim.api.nvim_create_autocmd
      :BufDelete
      {:buffer term.bufnr
       :callback (fn []
                   (close term)
                   (if term.on-exit (term:on-exit))
                   (set term.bufnr nil))}))

  (if (or (not term.bufnr) (not (vim.api.nvim_buf_is_valid term.bufnr)))
      (let [bufnr (mkbuf)]
        (set term.bufnr bufnr)
        (register-unload term)
        bufnr)
      term.bufnr))

(fn merge-fn [a b ...]
  (let [merged (if
                 (nil? a) b
                 (nil? b) a
                 (fn [...]
                   (a ...)
                   (b ...)))]
    (if (= 0 (select :# ...))
        merged
        (merge-fn merged ...))))

(lambda term-open [term]
  (fn on_exit []
    (set term.jobid nil)
    (close term)
    (if term.on-exit (term:on-exit))
    (when (select 1 (validate-bufnr term.bufnr))
      (vim.api.nvim_buf_delete term.bufnr {:force true})))

  (when (not term.jobid)
    (let [cmd   (make-cmd term.cmd)
          bufnr (term-bufnr term)
          jobid (run-in-buffer
                  bufnr
                  (fn []
                    (vim.fn.termopen
                      cmd
                      {:detach 1
                       : on_exit
                       :cwd term.cwd
                       :env term.env
                       :clear_env term.clear-env})))]
      (set term.jobid jobid)))
  (set-term term)
  nil)

(local term-is-open is-open)

(lambda term-close [term]
  (if (= term.behaviour :restart)
      (let [jobid term.jobid]
        (set term.jobid nil)
        (-?> jobid (vim.fn.jobstop)))
      (close term))
  nil)

(lambda term-toggle [term]
  ((if (term-is-open term) term-close term-open) term))

(fn make-term [{:cmd ?cmd : env : clear-env : cwd : behaviour : on-open
                : on-close : on-create : on-exit}]
  (vim.validate {:opts.env [env :t true]
                 :opts.clear-env [clear-env :b true]
                 :cwd [cwd :s true]
                 :behaviour [behaviour :s true]
                 :opts.on-open [on-open :f true]
                 :opts.on-close [on-close :f true]
                 :opts.on-create [on-create :f true]
                 :opts.on-exit [on-exit :f true]})
  (let [cmd (if
              (nil? ?cmd) nil
              (string? ?cmd) ?cmd
              (function? ?cmd) ?cmd
              (error "opts.cmd: Invalid cmd given"))]
    {: cmd
     : env
     : clear-env
     : cwd
     : behaviour
     : on-create
     : on-exit
     :is-open term-is-open
     :open term-open
     :close term-close
     :on-open (merge-fn
                (fn [term]
                  (run-in-buffer term.bufnr (fn [] (vim.cmd :startinsert!))))
                on-open)
     :on-close (merge-fn term-close on-close)
     :toggle term-toggle}))

{: close
 : is-open
 : set-term

 : make-term
 : term-close
 : term-is-open
 : term-open
 : term-toggle}

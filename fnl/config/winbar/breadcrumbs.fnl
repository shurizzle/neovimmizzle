(var states [])
(var cache [])
(autoload [{: ensure-winnr : stl-escape} :config.winbar.util])

(fn fire-event [winid]
  (tset cache winid nil)
  (pcall vim.api.nvim_win_call winid
         (fn []
           (vim.api.nvim_exec_autocmds :User {:pattern :NewBreadcrumbs}))))

(fn get-cursor [?winid]
  (let [tmp (vim.api.nvim_win_get_cursor (ensure-winnr ?winid))]
    {:line (dec (. tmp 1)) :character (. tmp 2)}))

(fn in-range? [cursor range]
  (if (and (= range.start.line range.end) (= range.start.line cursor.line))
      (and (<= range.start.character cursor.character)
           (>= range.end.character cursor.character))
      (= range.start.line cursor.line)
      (<= range.start.character cursor.character)
      (= range.end.line cursor.line)
      (>= range.end.character cursor.character)
      (and (> range.end.line cursor.line) (< range.start.line cursor.line))))

(fn extract-breadcrumbs [cursor symbols]
  (var breadcrumbs [])

  (fn traverse [symbols]
    (some (fn [{: range : name : kind : selectionRange : children}]
            (when (in-range? cursor range)
              (table.insert breadcrumbs {: name : kind :range selectionRange})
              children)) symbols))

  (var symbols symbols)
  (while symbols
    (set symbols (traverse symbols)))
  (if (empty? breadcrumbs)
      nil
      breadcrumbs))

(fn create-breadcrumbs [bufnr cursor]
  (-?>> ((. (require :config.winbar.lsp) :get-data) bufnr)
        (extract-breadcrumbs cursor)))

(fn get-or-create-state [winid ?bufnr]
  (when (not (. states winid))
    (let [cursor (get-cursor winid)
          bufnr (or ?bufnr (vim.api.nvim_win_get_buf winid))]
      (tset states winid
            {: cursor : bufnr :breadcrumbs (create-breadcrumbs bufnr cursor)}))
    (fire-event winid))
  (. states winid))

(fn cursor-moved [winid]
  (local state (get-or-create-state winid))
  (local cursor (get-cursor winid))
  (when (not (vim.deep_equal state.cursor cursor))
    (set state.cursor cursor)
    (set state.breadcrumbs (create-breadcrumbs state.bufnr cursor))
    (fire-event winid))
  false)

(fn buffer-changed [winid bufnr]
  (local state (. states winid))
  (if state
      (do
        (set state.bufnr bufnr)
        (set state.cursor {:line 1 :character 1})
        (set state.breadcrumbs (create-breadcrumbs bufnr state.cursor))
        (fire-event winid))
      (get-or-create-state winid bufnr))
  false)

(fn symbols-changed [bufnr]
  (each [winid s (pairs states)]
    (when (= s.bufnr bufnr)
      (set s.breadcrumbs (create-breadcrumbs bufnr s.cursor))
      (fire-event winid)))
  false)

(fn win-delete [winnr]
  (tset states winnr nil)
  (fire-event winnr)
  false)

(fn setup []
  (local mkaucmd vim.api.nvim_create_autocmd)
  (mkaucmd [:CursorMoved :CursorMovedI]
           {:callback #(cursor-moved (vim.api.nvim_get_current_win))})
  (mkaucmd :BufWinEnter
           {:callback #(buffer-changed (vim.api.nvim_get_current_win) $1.buf)})
  (mkaucmd :User {:pattern :NewDocumentSymbols
                  :callback #(symbols-changed $1.buf)})
  (mkaucmd :WinClosed {:callback #(win-delete (or (tonumber $1.match) 0))})
  (each [_ winid (ipairs (vim.api.nvim_list_wins))]
    (get-or-create-state winid)))

(fn get [?winid]
  (-?> (. states (ensure-winnr (or ?winid 0)))
       (. :breadcrumbs)
       (copy)))

(local icons {:File ""
              :Module ""
              :Namespace ""
              :Package ""
              :Class ""
              :Method ""
              :Property ""
              :Field ""
              :Constructor ""
              :Enum ""
              :Interface ""
              :Function ""
              :Variable ""
              :Constant ""
              :String ""
              :Number ""
              :Boolean ""
              :Array ""
              :Object ""
              :Key ""
              :Null "󰟢"
              :EnumMember ""
              :Struct ""
              :Event ""
              :Operator ""
              :TypeParameter ""})

(fn render-breadcrumb [data i]
  (local kind-name (. (require :config.winbar.lsp.transport) :SymbolKind
                      data.kind))
  (local res (.. (if kind-name (.. "%#BreadcrumbIcon" kind-name "#")
                     (not= 0 i) "%#BreadcrumbsBar#"
                     "")
                 (stl-escape (if kind-name (. icons kind-name) "?"))
                 (match (-?> data.name (trim))
                   (where name (not (empty? name))) (.. " %#BreadcrumbText#"
                                                        (stl-escape name))
                   _ "")))
  (if (not (empty? res))
      (.. "%" i "@GoToDocumentSymbol@" res "%X")
      res))

(fn render-breadcrumbs [data]
  (var res "")
  (each [index value (ipairs data)]
    (when (not (empty? res))
      (set res (.. res "%#BreadcrumbsSeparator# > ")))
    (set res (.. res (render-breadcrumb value index))))
  (if (not (empty? res))
      (.. "%#BreadcrumbsBar#" res "%*")
      res))

(fn render [?winid]
  (local winid (ensure-winnr (or ?winid 0)))
  (when (not (. cache winid))
    (tset cache winid (or (-?> (. states winid)
                               (. :breadcrumbs)
                               (render-breadcrumbs))
                          "")))
  (. cache winid))

(fn jump [i _ mouse]
  (when (not= :l mouse)
    (local winid (ensure-winnr 0))
    (local symbol (.? (get winid) i))
    (when symbol
      (vim.api.nvim_win_set_cursor winid
                                   [(inc symbol.range.start.line)
                                    symbol.range.start.character]))))

{: setup : get : icons : render : jump}

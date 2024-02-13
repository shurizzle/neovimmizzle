(fn props [def]
  (..
    "guifg=" (or def.fg :NONE)
    " guibg=" (or def.bg :NONE)
    " guisp=NONE blend=NONE"
    " gui=" (or def.gui :NONE)))

(fn [defs]
  (accumulate [res nil
               _ [name def] (ipairs defs)]
    (let [line (if
                 def.link     (.. "highlight! link " name " " def.link)
                 (empty? def) (.. "highlight clear " name)
                              (.. "highlight " name " " (props def)))]
      (if res (.. res "\n" line) line))))

(fn props [def]
  (.. :guifg= (or def.fg :NONE) " guibg=" (or def.bg :NONE)
      " guisp=NONE blend=NONE" " gui=" (or def.gui :NONE)))

(fn [defs ?pre]
  (let [pre (or ?pre "")]
    (accumulate [res nil _ [name def] (ipairs defs)]
      (let [line (if def.link
                     (.. pre "highlight! link " name " " def.link)
                     (empty? def)
                     (.. pre "highlight clear " name)
                     (.. pre "highlight " name " " (props def)))]
        (if res (.. res "\n" line) line)))))

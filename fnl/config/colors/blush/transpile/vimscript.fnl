(fn props [def]
  (.. :guifg= (or def.fg :NONE) " guibg=" (or def.bg :NONE)
      " guisp=NONE blend=NONE" " gui=" (or def.gui :NONE)))

(fn [defs ?pre]
  (let [pre (or ?pre "")]
    (accumulate [res nil _ [name def] (ipairs defs)]
      (let [line (if def.link (.. pre "highlight! link " name " " def.link)
                     (empty? def) (.. pre "highlight clear " name)
                     (and (= name :Normal) def.bg)
                     (.. "\tif get(g:, 'neovide')\n\t\thighlight " name
                         " guifg=" (or def.fg :NONE) " guibg=" (or def.bg :NONE)
                         " guisp=NONE blend=NONE" " gui=" (or def.gui :NONE)
                         "\n\telse\n\t\thighlight " name " guifg="
                         (or def.fg :NONE) " guibg=NONE"
                         " guisp=NONE blend=NONE" " gui=" (or def.gui :NONE)
                         "\n\tendif")
                     (.. pre "highlight " name " " (props def)))]
        (if res (.. res "\n" line) line)))))

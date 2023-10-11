(fn config []
  (let [{:default_opts opts} (require :nvim-surround.config)]
    (set opts.keymaps.insert nil)
    (set opts.keymaps.insert_line nil)
    (set opts.aliases [])
    ((. (require :nvim-surround) :setup))))

{:lazy true
 :keys [{:mode :n 1 :ys}
        {:mode :n 1 :yss}
        {:mode :n 1 :yS}
        {:mode :n 1 :ySS}
        {:mode :x 1 :S}
        {:mode :x 1 :gS}
        {:mode :n 1 :ds}
        {:mode :n 1 :cs}]
 : config}

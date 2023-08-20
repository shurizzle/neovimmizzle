(fn config []
  ((. (require :bufferline) :setup) {:auto_hide true})
  (let [sb (require :config.sidebar)
        api (require :bufferline.api)]
    (sb.on-resize (fn [width] (api.set_offset width (sb.get-name))))
    (sb.on-close (fn [] (api.set_offset 0)))))

{:lazy false
 : config}

(var resize-callbacks [])
(var close-callbacks [])
(var name nil)
(var closefn nil)

(fn resize [width]
  (vim.validate {:width [width :n]})
  (vim.schedule (fn []
                  (each [_ cb (ipairs resize-callbacks)]
                    (cb width)))))

(fn raw-close []
  (set name nil)
  (set closefn nil)
  (each [_ cb (ipairs close-callbacks)]
    (cb)))

(fn async-close [] (vim.schedule raw-close))

(fn get-name [] name)

(fn on-resize [cb]
  (vim.validate {:cb [cb :f]})
  (table.insert resize-callbacks cb))

(fn on-close [cb]
  (vim.validate {:cb [cb :f]})
  (table.insert close-callbacks cb))

(fn close [cb]
  (vim.validate {:cb [cb :f]})
  (fn on-close []
    (vim.schedule (fn []
                    (raw-close)
                    (cb))))
  (if closefn (closefn on-close) (on-close)))

(fn register [widget-name close-function cb]
  (vim.validate {:widget-name [widget-name :s]
                 :close-function [close-function :f]
                 :cb [cb :f]})
  (close (fn []
           (set name widget-name)
           (set closefn close-function)
           (cb {: resize :close async-close}))))

{: get-name
 :get_name get-name
 : on-resize
 :on_resize on-resize
 : on-close
 :on_close on-close
 : close
 : register}

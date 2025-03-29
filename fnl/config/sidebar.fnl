(var resize-callbacks [])
(var close-callbacks [])
(var name nil)
(var closefn nil)

(fn resize [width]
  (vim.validate :width width :number)
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
  (vim.validate :cb cb :function)
  (table.insert resize-callbacks cb))

(fn on-close [cb]
  (vim.validate :cb cb :function)
  (table.insert close-callbacks cb))

(fn close [cb]
  (vim.validate :cb cb :function)

  (fn on-close []
    (vim.schedule (fn []
                    (raw-close)
                    (cb))))

  (if closefn (closefn on-close) (on-close)))

(fn register [widget-name close-function cb]
  (vim.validate :widget-name widget-name :string)
  (vim.validate :close-function close-function :function)
  (vim.validate :cb cb :function)
  (close (fn []
           (set name widget-name)
           (set closefn close-function)
           (cb {: resize :close async-close}))))

{: get-name : on-resize : on-close : close : register}

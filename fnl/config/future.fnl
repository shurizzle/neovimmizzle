(local Future {})
(set Future.__index Future)

(fn instance-of [subject super]
  (let [super (tostring super)]
    (var mt (getmetatable subject))
    (while true
      (if (nil? mt) (lua "return false"))
      (if (= super (tostring mt)) (lua "return true"))
      (set mt (getmetatable mt)))))

(fn Future.new [cb]
  (vim.validate {:cb [cb :f]})
  (var o {:resolved  nil
          :state     []
          :callbacks {:ok [] :ko []}})
  (setmetatable o Future)

  (fn run [resolved state callbacks]
    (set o.resolved resolved)
    (set o.state state)
    (set o.callbacks nil)
    (each [_ f (ipairs callbacks)]
      (vim.schedule (fn [] (f o.state)))))
  (let [(ok err) (pcall cb (fn [res] (run true  res o.callbacks.ok))
                           (fn [err] (run false err o.callbacks.ko)))]
    (if (not ok) (run false err o.callbacks.ko)))
  o)
(set Future.future Future.new)

(fn Future.resolved [state]
  (var o {:resolved true
          : state})
  (setmetatable o Future)
  o)

(fn Future.rejected [state]
  (var o {:resolved false
          : state})
  (setmetatable o Future)
  o)

(fn Future.wrap [val]
  (if (instance-of val Future)
      val
      (Future.resolved val)))

(fn Future.pcall [f ...]
  (let [(ok res) (pcall f ...)]
    (if ok
        (Future.wrap res)
        (Future.rejected res))))

(fn Future.and_then [self cb catch-cb]
  (vim.validate {:cb [cb :f true]
                 :catch-cb [catch-cb :f true]})
  (if (boolean? self.resolved)
      (if self.resolved
          (if cb
              (Future.pcall cb self.state)
              self)
          (if catch-cb
              (Future.pcall catch-cb self.state)
              self))
      (if (or cb catch-cb)
          (Future.new
            (fn [resolve reject]
              (table.insert self.callbacks.ok
                            (fn [res]
                              (if cb
                                  (: (Future.pcall cb res) :and-then
                                     resolve reject)
                                  (resolve res))))
              (table.insert self.callbacks.ko
                            (fn [res]
                              (if catch-cb
                                  (: (Future.pcall catch-cb res) :and-then
                                     resolve reject)
                                  (resolve res))))))
          self)))
(set Future.and-then Future.and_then)

(fn Future.catch [self cb] (Future.and-then self nil cb))

(fn Future.finally [self cb]
  (vim.validate {:cb [cb :f true]})
  (if cb
      (Future.and-then self (fn [res] (cb true  res))
                            (fn [err] (cb false err)))
      self))

(fn Future.join [futures]
  (vim.validate {:futures [futures :t]})

  (local len (count futures))
  (if (= 0 len)
      (Future.resolved [])
      (do
        (var results [])
        (var resolve nil)
        (var joined (Future.new (fn [a] (set resolve a))))
        (each [index _ (ipairs futures)]
          (: (. futures index) :finally
             ((fn [i]
                (fn [ok res]
                  (tset results i [ok res])
                  (if (= len (count results)) (resolve results)))) index)))
        joined)))

Future

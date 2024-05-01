(autoload [{: callback-memoize} :config.lang.util])

(local *installers* [])

(fn get* [what]
  (let [installer (. *installers* what)]
    (if installer
        installer
        (let [(ok fmt) (pcall require (.. :config.lang.formatter. what))]
          (when ok
            (let [inst (callback-memoize fmt)]
              (tset *installers* what inst)
              inst))))))

(setmetatable {} {:__index (fn [_ name] (get* name)) :__newindex (fn [])})

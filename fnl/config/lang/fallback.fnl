(fn which [...]
  (some (fn [name] (and (executable name) name)) [...]))

(fn [name ...]
  (let [bin (if (= 0 (select :# ...)) (which name) (which ...))
        {: rejected : resolved} (require :config.future)]
    (if (nil? bin)
        (rejected (.. name ": binary not found"))
        (do
          (vim.notify "Fallbacking to the system one"
                      vim.log.levels.WARN {:title name})
          (resolved bin)))))

(local {: view} (require :fennel))
(local color (require :config.colors.blush.color))
(local {: compile} (require :config.colors.blush.compile))
(local unpack (or table.unpack _G.unpack))

(fn merge! [res & args]
  (each [_ map (ipairs args)]
    (each [k v (pairs map)]
      (when (not= :string (type k))
        (error (.. "Invalid key " (view k))))
      (when (not= nil (. res k))
        (error (.. "Duplicated key " k)))
      (tset res k v)))
  res)

(local merge (partial merge! []))

(merge! {: merge!
         : merge
         : compile}
        color)

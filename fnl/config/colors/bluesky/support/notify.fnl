(import-macros {: blush} :config.colors.blush.macros)

;; fnlfmt: skip
(fn [cp] 
  (blush
    (NotifyBackground :bg cp.bg+)))

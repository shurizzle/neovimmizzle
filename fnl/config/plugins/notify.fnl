(fn lazy-notify [...]
  (let [{: notify} (require :notify)]
    (set vim.notify notify)
    (notify ...)))

{:lazy   false
 :cond   (not (. (require :config.platform) :is :headless))
 :cmd    :Notifications
 :init   (fn [] (set vim.notify lazy-notify))}

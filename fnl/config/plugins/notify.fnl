(fn lazy-notify [...]
  (let [notify (require :notify)]
    (notify.setup [])
    (set vim.notify notify)
    (notify ...)))

{:lazy true
 :cond (not (. (require :config.platform) :is :headless))
 :cmd :Notifications
 :init (fn [] (set vim.notify lazy-notify))}

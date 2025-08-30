(fn lazy-notify [...]
  (let [{: notify} (require :notify)]
    (set vim.notify notify)
    (notify ...)))

(fn dismiss []
  (let [{: dismiss} (require :notify)]
    (dismiss {:pending false :silent true})))

(let [h (. (require :config.platform) :is :headless)]
  {:lazy false
   :cond (not h)
   :cmd :Notifications
   :init (fn []
           (when (not h)
             (vim.keymap.set :n :<leader>nd dismiss
                             {:silent true :desc "Dismiss all notifications"}))
           (set vim.notify lazy-notify))})

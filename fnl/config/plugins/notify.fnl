{:lazy false
 :cond (not (. (require :config.platform) :is :headless))
 :config (fn []
           (let [notify (require :notify)] 
             (notify.setup []) (set vim.notify notify)))}

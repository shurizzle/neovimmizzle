(: (. (require :config.lang.installer) :omnisharp) :and-then
   (fn []
     ((. (require :lspconfig) :omnisharp :setup) {:cmd [:omnisharp]})))

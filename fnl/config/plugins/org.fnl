(fn build []
  ((. (require :orgmode) :setup_ts_grammar))
  (((. (require :nvim-treesitter.install) :update)
    {:with_sync (. (require :config.platform) :is :headless)})))

(fn config []
  (let [org (require :orgmode)]
    (org.setup_ts_grammar)
    (org.setup [])))

{:dependencies :nvim-treesitter/nvim-treesitter
 :ft :org
 :keys [{:mode :n 1 :<leader>oa}
        {:mode :n 1 :<leader>oc}]
 : build
 : config}

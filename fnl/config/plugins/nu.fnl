(fn build []
  (require :nu)
  (((. (require :nvim-treesitter.install) :update)
    {:with_sync (. (require :config.platform) :is :headless)})))

{:lazy true
 :dependencies :nvim-treesitter/nvim-treesitter
 :ft :nu
 : build
 :config (fn [] ((. (require :nu) :setup)))}

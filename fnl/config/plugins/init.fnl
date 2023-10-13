(var after-load nil)
(var loaded false)
(fn -after-load []
  (when (not loaded)
      (set loaded true)
      (if (= :function (type after-load)) (after-load))))

(local {:Spec {:get_name plugin-name}} (require :lazy.core.plugin))

(fn remap [plugin]
  (when (not plugin.name)
    (set plugin.name (plugin-name (. plugin 1))))
  (match (pcall require (.. :config.plugins. plugin.name))
    (false _) plugin
    (true conf) (vim.tbl_deep_extend :force plugin conf)))

(var config (icollect [_ plugin (ipairs (require :config.plugins._))]
              (remap plugin)))

(table.insert config   {1 :rktjmp/lush.nvim
                        :name :lush
                        :lazy true
                        :cmd  [:LushRunQuickstart :LushRunTutorial :Lushify]})
(table.insert config 1 {1 :lewis6991/impatient.nvim
                        :lazy false
                        :cond (not (has :nvim-0.9.0))})
(table.insert config 1 {1 :rktjmp/hotpot.nvim :lazy false})
(table.insert config 1 {1 :folke/lazy.nvim :lazy false :tag :stable})
(table.insert config 1 {1 :williamboman/mason.nvim
                        :lazy true
                        :cmd  [:Mason :MasonInstall :MasonLog :MasonUninstall
                               :MasonUninstallAll]
                        :main :mason
                        :opts {:PATH :skip}})
(table.insert config 1 {1 :nvim-lua/plenary.nvim :lazy true})

((. (require :lazy) :setup) config {:dev {:path "~/p"}})
(-after-load)

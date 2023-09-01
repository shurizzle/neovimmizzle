(var after-load nil)
(var loaded false)
(fn -after-load []
  (when (not loaded)
      (set loaded true)
      (if (= :function (type after-load)) (after-load))))

(fn remap [plugin]
  (if (= :string (type plugin.mod))
      (let [mod plugin.mod]
        (set plugin.mod nil)
        (->> mod
             (.. :config.plugins.)
             (require)
             (vim.tbl_deep_extend :force plugin)))
      plugin))

(var config (icollect [_ plugin (ipairs (require :config.plugins._))] (remap plugin)))

(table.insert config {1 :rktjmp/lush.nvim
                      :name :lush
                      :lazy true
                      :cmd [:LushRunQuickstart :LushRunTutorial :Lushify]})

(table.insert config 1 {1 :lewis6991/impatient.nvim :lazy false :cond (not (has :nvim-0.9.0))})
(table.insert config 1 {1 :shurizzle/hotpot.nvim :lazy false})
; (table.insert config 1 {1 :rktjmp/hotpot.nvim :lazy false})
(table.insert config 1 {1 :folke/lazy.nvim :lazy false})
(table.insert config 1 {1 :williamboman/mason.nvim
                        :lazy false
                        :cmd [:Mason :MasonInstall :MasonLog :MasonUninstall :MasonUninstallAll]
                        :config (fn [] ((. (require :mason) :setup) []))})

((. (require :lazy) :setup) config)
(-after-load)

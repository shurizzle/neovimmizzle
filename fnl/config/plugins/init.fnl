(var after-load nil)
(var loaded false)
(fn -after-load []
  (when (not loaded)
      (set loaded true)
      (if (= :function (type after-load)) (after-load))))

(local {:Spec {:get_name plugin-name}} (require :lazy.core.plugin))

(fn remap [plugin]
  (fn deps [spec]
    (if (and spec.deps spec.dependencies)
        (assert false (.. "Both deps and dependencies fields set in "
                          (. spec 1))))
    (when spec.deps
      (set spec.dependencies spec.deps)
      (set spec.deps nil))
    spec)

  (when (not plugin.name)
    (set plugin.name (plugin-name (. plugin 1))))
  (deps (match (pcall require (.. :config.plugins. plugin.name))
          (false _) plugin
          (true conf) (vim.tbl_deep_extend :force plugin conf))))

(var config (icollect [_ plugin (ipairs (require :config.plugins._))]
              (remap plugin)))

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
(table.insert config 1 {1 :nvim-lua/plenary.nvim :lazy true :name :plenary})

((. (require :lazy) :setup) config {:dev {:path "~/p"}})
(-after-load)

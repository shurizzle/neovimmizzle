(autoload [lspconfig :lspconfig
           util :lspconfig.util])

(fn register []
  (local root_dir "root_pattern(\"main.roc\", \".git\")")
  (tset (require :lspconfig.configs) :roc_ls
       {:default_config {:cmd [:roc_ls]
                         :filetypes [:roc]
                         :root_dir (util.root_pattern :main.roc :.git)
                         :docs {:description ""
                                :default_config {:cmd [:roc_ls]
                                                 : root_dir}}}}))

(fn [cb]
  (register)
  (lspconfig.roc_ls.setup [])
  (cb lspconfig.roc_ls))

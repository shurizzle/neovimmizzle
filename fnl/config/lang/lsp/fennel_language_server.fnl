(: (. (require :config.lang.installer) :fennel-language-server) :and-then
   (fn []
     (let [lspconfig (require :lspconfig)
           {:global-unmangling unmangle} (require :fennel.compiler)
           globals (keys (collect [key _ (pairs _G)] (values (unmangle key) true)))]
       (lspconfig.fennel_language_server.setup
         {:root_dir (lspconfig.util.root_pattern :fnl)
          :settings {:fennel {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                              :diagnostics {: globals}}}}))))

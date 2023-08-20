{:config (fn [] (: (. (require :config.lang.lsp) :taplo) :catch
                   ((require :config.lang.fallback) :taplo)))}
